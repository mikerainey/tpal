{ myPkgs ? import ((import <nixpkgs> {}).fetchzip {url="https://github.com/mikerainey/nix-packages/archive/refs/heads/main.zip"; sha256="175lp0lsdh90z1h4ycy9ay9wzfac39c2ang7a2bys2clymhy7jxw";}) {},
  pkgs ? myPkgs.pkgs
}:

pkgs.mkShell rec {
  name = "tpal-benchmark";

  buildInputs = [
    myPkgs.cmdline myPkgs.mcsl myPkgs.cilk-plus-rts-with-stats
    pkgs.gcc7 pkgs.papi pkgs.which pkgs.jemalloc pkgs.hwloc
  ];
  
  shellHook =
    ''
    export CMDLINE_PATH="${myPkgs.cmdline}"
    export CPP=${pkgs.gcc7}/bin/g++
    export CC=${pkgs.gcc7}/bin/gcc
    export MCSL_PATH="${myPkgs.mcsl}/include/"
    export PAPI_PREFIX="${pkgs.papi}"
    export HWLOC_INCLUDE_PREFIX="-DMCSL_HAVE_HWLOC -I${pkgs.hwloc.dev}/include/"
    export HWLOC_LIBRARY_PREFIX="-L${pkgs.hwloc.lib}/lib/ -lhwloc"
    export CILK_EXTRAS_PREFIX="-L ${myPkgs.cilk-plus-rts-with-stats}/lib -I ${myPkgs.cilk-plus-rts-with-stats}/include -ldl -DCILK_RUNTIME_WITH_STATS"
  '';
  
}
