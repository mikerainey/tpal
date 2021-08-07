{ mypkgs ? import ((import <nixpkgs> {}).fetchzip {url="https://github.com/mikerainey/nix-packages/archive/refs/heads/main.zip"; sha256="1zw7y1lpmbyzsbhyil6jby85gb7marjcgqm08x8qnnbmn1il1zch";}) {},
  pkgs ? mypkgs.pkgs
}:

pkgs.mkShell rec {
  name = "tpal-benchmark";

  buildInputs = [mypkgs.cmdline];
  
  shellHook =
    ''
    export CMDLINE_PATH="${mypkgs.cmdline}"
  '';
  
}
