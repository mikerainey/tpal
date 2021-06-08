#let pkgs = import <nixpkgs> {}; in
let pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/tags/20.09.tar.gz") {}; in

let mcslSrc = pkgs.fetchFromGitHub {
      owner  = "mikerainey";
      repo   = "mcsl";
      rev    = "5ac7bfcae5b813707906e79acf16f35b5e67154c";
      sha256 = "15glkga07rk2nky07a5pkmddra4kq2vk7rhy3wclyngvjc6622qx";
    };
    cmdlineSrc = pkgs.fetchFromGitHub {
      owner  = "deepsea-inria";
      repo   = "cmdline";
      rev    = "67b01773169de11bf04253347dd1087e5863a874";
      sha256 = "1bzmxdmnp7kn6arv3cy0h4a6xk03y7wdg0mdkayqv5qsisppazmg";
    };
    pbenchSrc = pkgs.fetchFromGitHub {
      owner  = "mikerainey";
      repo   = "pbench";
      rev    = "38cfcfff1bc8bed077fae6a14c1dedfd68549a92";
      sha256 = "0ymp5jmdm9572d4ahxzf5sy7icd9frchyc6nkp7yw31mmh8w99ff";
    };
    cilkRtsSrc = pkgs.fetchFromGitHub {
      owner  = "deepsea-inria";
      repo   = "cilk-plus-rts-with-stats";
      rev    = "d143c31554bc9c122d168ec22ed65e7941d4c91d";
      sha256 = "123bsrqcp6kq6xz2rn4bvj2nifflfci7rd9ij82fpi2x6xvvsmsb";
    };
    tpalrtsSrc = ../../.;
in

{

  mcsl = "${mcslSrc}/nix/default.nix";
  
  cmdline = "${cmdlineSrc}/script/default.nix";

  cilk-plus-rts-with-stats = import "${cilkRtsSrc}/default.nix" { pkgs = pkgs; };

  tpalrtsSrc = tpalrtsSrc;

  benchOcamlSrc = "${tpalrtsSrc}/runtime/bench/";

  pbenchOcamlSrcs = import "${pbenchSrc}/nix/local-sources.nix";
}
