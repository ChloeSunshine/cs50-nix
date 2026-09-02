{
  description = "Harvard CS50 environment replica";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {self, nixpkgs, flake-utils, ...}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };
        pythonPackages = pkgs.python3Packages;
      in rec {
        devShells.default = pkgs.mkShell {
          name = "impurePythonEnv";
          venvDir = "./.venv";
          buildInputs = [
            pkgs.libcs50
            pkgs.gcc
            pkgs.clang
            pkgs.glibc
            pkgs.gnumake
            pkgs.valgrind
            pythonPackages.python
            pythonPackages.venvShellHook
            pythonPackages.pip
          ];
          postVenvCreation = ''
            unset SOURCE_DATE_EPOCH
            pip install --upgrade pip
            pip install check50
          '';
          shellHook = ''
            export MAKEFLAGS="-s"
            export LDLIBS="-l:libcs50.a"
            export LD_LIBRARY_PATH="${pkgs.libcs50}/lib:$LD_LIBRARY_PATH"
          '';
          postShellHook = ''
            unset SOURCE_DATE_EPOCH
          '';
        };
      }
    );
}
