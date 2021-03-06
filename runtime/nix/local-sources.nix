let pkgs = import <nixpkgs> {}; in
let
  cmdlineSrc = pkgs.fetchFromGitHub {
    owner  = "deepsea-inria";
    repo   = "cmdline";
    rev    = "67b01773169de11bf04253347dd1087e5863a874";
    sha256 = "1bzmxdmnp7kn6arv3cy0h4a6xk03y7wdg0mdkayqv5qsisppazmg";
  };

  # mcslSrc = pkgs.fetchFromGitHub {
  #   owner  = "mikerainey";
  #   repo   = "mcsl";
  #   rev    = "4c584c85a3906c7cb608804e98a8886a78b120a5";
  #   sha256 = "0c10x5jn170i9jgrafcf5y8gdrdganxb9jrjq7km8v03svcl7kya";
  # };

  mcslSrc = ../../../mcsl;

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

  pbenchOcamlSrcs = import "${pbenchSrc}/nix/local-sources.nix";

  tpalrtsSrc = ../../.;
in

{
  cmdline = "${cmdlineSrc}/script/default.nix";
  cilk-plus-rts-with-stats = import "${cilkRtsSrc}/default.nix" { };
  mcsl = "${mcslSrc}/nix/default.nix";
  tpalrtsSrc = tpalrtsSrc;
  benchOcamlSrc = "${tpalrtsSrc}/runtime/bench/";
  pbenchOcamlSrcs = pbenchOcamlSrcs;
}
