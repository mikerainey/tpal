let pkgs = import <nixpkgs> {}; in

let mcslSrc = pkgs.fetchFromGitHub {
      owner  = "mikerainey";
      repo   = "mcsl";
      rev    = "9b33a08ed824f4c3613ca324a744ff68c92932de";
      sha256 = "1rxxl861dxizjkwiig582sglb56k8mbl567lgl1jp4dmg6m1p4w5";
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

  cilk-plus-rts-with-stats = import "${cilkRtsSrc}/default.nix" { };

  tpalrtsSrc = tpalrtsSrc;

  benchOcamlSrc = "${tpalrtsSrc}/runtime/bench/";

  pbenchOcamlSrcs = import "${pbenchSrc}/nix/local-sources.nix";
}
