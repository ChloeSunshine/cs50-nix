# cs50-nix

A NixOS-friendly development environment for [Harvard's CS50](https://cs50.harvard.edu/), forked from [t-spr/cs50-nix-shell](https://github.com/t-spr/cs50-nix-shell) and updated to work on current nixpkgs.

Provides `gcc`, `clang`, `gdb`, `valgrind`, `make`, `libcs50`, and a Python venv with `check50` pre-installed

## Usage

```bash
nix develop github:ChloeSunshine/cs50-nix
```
or
```bash
nix-shell https://github.com/ChloeSunshine/cs50-nix/archive/main.tar.gz
``` 

This drops you into a shell with everything CS50 expects on `$PATH`, and activates a Python venv (`./.venv`) with `check50` installed. Once inside, compiling works exactly like the CS50 IDE

You will need an editor. You can use VSCode as they did in the video. I'm using zed because it has a vim mode, and I like neovim.

I'm currently going through the course with [this](https://www.youtube.com/watch?v=gmuTjeQUbTM) shell, and will update it further if any issues occur. I followed this course. Happy learning!

## License

GPLv3
