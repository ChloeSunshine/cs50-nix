# cs50-nix

A NixOS-friendly development environment for [Harvard's CS50](https://cs50.harvard.edu/), forked from [t-spr/cs50-nix-shell](https://github.com/t-spr/cs50-nix-shell) and updated to work on current nixpkgs.

Provides `gcc`, `clang`, `gdb`, `valgrind`, `make`, `libcs50`, and a Python venv with `check50` pre-installed

## Usage

```bash
nix develop github:ChloeSunshine/cs50-nix-shell
```
or
```bash
nix-shell https://github.com/ChloeSunshine/cs50-nix-shell/archive/main.tar.gz
``` 

This drops you into a shell with everything CS50 expects on `$PATH`, and activates a Python venv (`./.venv`) with `check50` installed. Once inside, compiling works exactly like the CS50 IDE

## License

GPLv3
