with import <nixpkgs> { };

let
  pythonPackages = python3Packages;
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
in pkgs.mkShell rec {
  name = "impurePythonEnv";
  venvDir = "./.venv";
  buildInputs = [
    unstable.libcs50
    pkgs.gcc
    pkgs.clang
    pkgs.glibc
    pkgs.gnumake
    pkgs.valgrind
    pythonPackages.python
    # This executes some shell code to initialize a venv in $venvDir before
    # dropping into the shell
    pythonPackages.venvShellHook
    pythonPackages.pip
  ];
    
  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    pip install --upgrade pip
    pip install check50
  '';  

  postShellHook = ''
    # allow pip to install wheels
    unset SOURCE_DATE_EPOCH/
  '';
}
