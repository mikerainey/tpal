with import <nixpkgs> {};
let
  my-python-packages = python-packages: [
    python-packages.pexpect
  ];
  my-python = python36.withPackages my-python-packages;
in
  pkgs.mkShell {
    buildInputs = [
      bashInteractive
      my-python
    ];
    shellHook = ''
      unset SOURCE_DATE_EPOCH
    '';
  }
