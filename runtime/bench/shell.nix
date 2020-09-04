{ pkgs   ? import <nixpkgs> {},
  stdenv ? pkgs.stdenv,
  sources ? import ../nix/local-sources.nix,
  cmdline ? import sources.cmdline {},
  mcsl ? import sources.mcsl {},
  gcc ? pkgs.gcc7,
  hwloc ? pkgs.hwloc,
  gperftools ? pkgs.gperftools,
  papi ? pkgs.papi,
  jemalloc ? pkgs.jemalloc450 # use jemalloc, unless this parameter equals null (for now, use v4.5.0, because 5.1.0 has a deadlock bug)
  # pviewSrc ? pkgs.fetchFromGitHub {
  #   owner  = "deepsea-inria";
  #   repo   = "pview";
  #   rev    = "78d432b80cc1ea2767e1172d56e473f484db7f51";
  #   sha256 = "1hd57237xrdczc6x2gxpf304iv7xmd5dlsvqdlsi2kzvkzysjaqn";
  # }
}:

stdenv.mkDerivation rec {
  name = "microbench";

  src = ./.;

  buildInputs =
    [ hwloc gcc ]
    ++ (if jemalloc == null then [] else [ jemalloc ]);
  
  shellHook =
    # let pviewExport =
    #   if pviewSrc == null then ""
    #   else
    #     let pview = import "${pviewSrc}/default.nix" {}; in
    #     "export PATH=${pview}/bin:$PATH";
    # in
    ''
    export CPP="${gcc}/bin/g++"
    export CC="${gcc}/bin/gcc"
    export CMDLINE_PATH="${cmdline}/include/"
    export MCSL_PATH="${mcsl}/include/"
    export PAPI_PREFIX="${papi}"
    export HWLOC_INCLUDE_PREFIX="-DMCSL_HAVE_HWLOC -I${hwloc.dev}/include/"
    export HWLOC_LIBRARY_PREFIX="-L${hwloc.lib}/lib/ -lhwloc"
    export PATH=${gcc}/bin/:$PATH
  '';
  #    ${pviewExport}
  
}
