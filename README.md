# cava-wsl

dotfiles & install scripts for a Debian WSL container that I run `cava` under using [`winscap.exe`](https://github.com/quantum5/winscap)

## Contents:

- [`install.ps1`](./install.ps1) - to be run in a `powershell`/`pwsh` shell, installs dependancies % sets up configs
- [`launch.sh`](./launch.sh) - used to launch `cava` and `winscap`

## Dependancies:

*these will be installed by `install.ps1`*

- `winscap` (in Windows host)
- `cava`
- `git`
- `gh` (sometimes known as `github-cli`)
- `neofetch` (not technically needed but is installed by `install.ps1` anyway)
