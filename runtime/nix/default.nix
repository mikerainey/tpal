{ pkgs   ? import <nixpkgs> {},
  stdenv ? pkgs.stdenv,
  gcc ? pkgs.gcc7,
  R ? pkgs.R,
  myTexlive ? pkgs.texlive.combined.scheme-small,
  makeWrapper ? pkgs.makeWrapper,
  which ? pkgs.which,
  hwloc ? pkgs.hwloc,
  papi ? pkgs.papi,
  jemalloc ? pkgs.jemalloc450, # use jemalloc, unless this parameter equals null (for now, use v4.5.0, because 5.1.0 has a deadlock bug)
  buildDunePackage ? pkgs.ocamlPackages.buildDunePackage,
  sources ? import ./local-sources.nix,
  tpalrtsSrc ? sources.tpalrtsSrc,
  cmdline ? import sources.cmdline {},
  mcsl ? import sources.mcsl {},
  pbenchOcaml ? import sources.pbenchOcamlSrcs.pbenchOcaml { pbenchOcamlSrc = sources.pbenchOcamlSrcs.pbenchOcamlSrc; }
}:

let benchDune =
      buildDunePackage rec {
        pname = "bench";
        version = "1.0";
        src = sources.benchOcamlSrc;
        buildInputs = [ pbenchOcaml ];
      };
in

let bench =
      import sources.pbenchOcamlSrcs.pbenchCustom { benchSrc = sources.benchOcamlSrc;
                                                    bench = "${benchDune}/bin/bench"; };
in

stdenv.mkDerivation rec {
  name = "heartbeat_microbench";

  src = tpalrtsSrc;

  buildInputs =
    [ hwloc makeWrapper R gcc papi which ]
    ++ (if jemalloc == null then [] else [ jemalloc ]);

  configurePhase =
    let getNbCoresScript = pkgs.writeScript "get-nb-cores.sh" ''
        #!/usr/bin/env bash
        nb_cores=$( ${hwloc}/bin/hwloc-ls --only core | wc -l )
        echo $nb_cores
        '';
    in
    ''
    cp ${getNbCoresScript} get-nb-cores.sh
    '';

  enableParallelBuilding = true;
  
  buildPhase =
    let
      jemallocCfg = 
        if jemalloc == null then
          ""
        else
          "export PATH=${jemalloc}/bin:$PATH";
    in
    ''
    make -C runtime/bench clean
    make \
       -j $NIX_BUILD_CORES \
       -C runtime/bench \
       all \
       CPP=${gcc}/bin/g++ \
       CC=${gcc}/bin/gcc \
       CMDLINE_PATH="${cmdline}/include/" \
       MCSL_PATH="${mcsl}/include/" \
       PAPI_PREFIX="${papi}" \
       HWLOC_INCLUDE_PREFIX="-DMCSL_HAVE_HWLOC -I${hwloc.dev}/include/" \
       HWLOC_LIBRARY_PREFIX="-L${hwloc.lib}/lib/ -lhwloc"
  '';

  installPhase =
    ''
    mkdir -p $out

    make install \
      -C runtime/bench \
      INSTALL_FOLDER=$out
    cp get-nb-cores.sh $out/

    cp ${bench}/bench $out/bench
    wrapProgram $out/bench \
        --prefix PATH ":" $out/ \
        --add-flags "-skip make"
  '';
  
  meta = {
    description = "Microbenchmark to evaluate the performance of the heartbeat mechanism used by Heartbeat Scheduling";
    license = "MIT";
  };
}
