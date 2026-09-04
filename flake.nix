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
            # Ensure Flatpak and local binary paths are visible
            export PATH="$HOME/.local/share/flatpak/exports/bin:$HOME/.local/bin:$PATH"

            # 1. Prioritize terminal program detection first
            if [ "$TERM_PROGRAM" = "vscode" ]; then
              export EDITOR="code"
            elif [ "$TERM_PROGRAM" = "zed" ]; then
              # Check if system has zeditor (NixOS) or flatpak zed
              if command -v zeditor >/dev/null 2>&1; then
                export EDITOR="zeditor"
              else
                export EDITOR="zed"
              fi
            # 2. Otherwise, auto-detect available editors
            elif [ -z "$EDITOR" ] || [ "$EDITOR" = "nano" ]; then
              if command -v code >/dev/null 2>&1; then
                export EDITOR="code"
              elif command -v zeditor >/dev/null 2>&1; then
                export EDITOR="zeditor"
              elif command -v zed >/dev/null 2>&1; then
                export EDITOR="zed"
              elif command -v subl >/dev/null 2>&1; then
                export EDITOR="subl"
              elif command -v nvim >/dev/null 2>&1; then
                export EDITOR="nvim"
              else
                export EDITOR="nano"
              fi
            fi

            # Universal 'code' helper function
            code() {
              touch -- "$1"

              if [ "$EDITOR" = "code" ] || [ "$(basename "$EDITOR")" = "code" ]; then
                command code --wait "$1"
              elif [ "$EDITOR" = "zeditor" ] || [ "$(basename "$EDITOR")" = "zeditor" ]; then
                zeditor "$1"
              elif [ "$EDITOR" = "zed" ]; then
                flatpak run dev.zed.Zed "$1"
              elif [ -n "$EDITOR" ]; then
                $EDITOR "$1"
              else
                nano "$1"
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
