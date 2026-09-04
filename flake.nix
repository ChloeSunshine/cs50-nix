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
            export LDLIBS="-l:libcs50.a"
            export LD_LIBRARY_PATH="${pkgs.libcs50}/lib:$LD_LIBRARY_PATH"
            #COMPLETELY UNTESTED START
            case "$TERM_PROGRAM" in
              vscode)
                command -v code >/dev/null 2>&1 && export EDITOR="code --wait"
                ;;
              zed)
                command -v zed >/dev/null 2>&1 && export EDITOR="zed"
                ;;
            esac

            code() {
              touch -- "$1"
              if [ -n "$EDITOR" ]; then
                "$EDITOR" "$1"
              else
                echo "Created $1 — set \$EDITOR (e.g. export EDITOR=zed) to have 'code' open it automatically next time."
              fi
            }
          #END
          '';
          postShellHook = ''
            unset SOURCE_DATE_EPOCH
          '';
        };
      }
    );
}
