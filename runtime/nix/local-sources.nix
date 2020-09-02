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
    rev    = "1c90259b594b6612bc6b9973564e89c297ad17b3";
    sha256 = "1440zavl3v74hcyg49h026vghhj1rv5lhfsb5rgfzmndfynzz7z0";
  };
  
  pbenchOcamlSrcs = import "${pbenchSrc}/nix/local-sources.nix";

  tpalrtsSrc = ../../.;
in

{
  cmdline = "${cmdlineSrc}/script/default.nix";
  mcsl = "${mcslSrc}/nix/default.nix";
  tpalrtsSrc = tpalrtsSrc;
  benchOcamlSrc = "${tpalrtsSrc}/runtime/bench/";
  pbenchOcamlSrcs = pbenchOcamlSrcs;
}
