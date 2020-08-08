let pkgs = import <nixpkgs> {}; in

let mcslSrc = pkgs.fetchFromGitHub {
      owner  = "mikerainey";
      repo   = "mcsl";
      rev    = "7612000608ba7a77a42d8c7490797b611aaf8c2c";
      sha256 = "0smgqdq8ykq8n8v3jdhx2m9ycgdsg36gjn3239ifk7k1wmyjwwpk";
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
      rev    = "1c90259b594b6612bc6b9973564e89c297ad17b3";
      sha256 = "1440zavl3v74hcyg49h026vghhj1rv5lhfsb5rgfzmndfynzz7z0";
    };
    tpalrtsSrc = ../../.;
in

{

  mcsl = "${mcslSrc}/nix/default.nix";
  
  cmdline = "${cmdlineSrc}/script/default.nix";

  tpalrtsSrc = tpalrtsSrc;

  benchOcamlSrc = "${tpalrtsSrc}/runtime/bench/";

  pbenchOcamlSrcs = import "${pbenchSrc}/nix/local-sources.nix";
}
