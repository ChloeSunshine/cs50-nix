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
            export MAKEFLAGS="-s"

            case "$TERM_PROGRAM" in
                vscode)
              if code --version >/dev/null 2>&1; then
                export EDITOR="code --wait"
              fi
              ;;
                zed)
                if zed --version >/dev/null 2>&1; then
                  export EDITOR="zed"
                fi
             ;;
           esac

           code() {
             touch -- "$1"
             if [ -n "$EDITOR" ]; then
               if ! "$EDITOR" "$1"; then
                 echo "'$EDITOR' failed to open $1. Falling back to \$VISUAL or a plain editor may help."
               fi
             else
               echo "Created $1 — set \$EDITOR (e.g. export EDITOR=zed) to have 'code' open it automatically next time."
             fi
            }
          '';
          postShellHook = ''
            unset SOURCE_DATE_EPOCH
          '';
        };
      }
    );
}
