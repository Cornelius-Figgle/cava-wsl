# cava-wsl

dotfiles & install scripts for a Debian WSL container that I run `cava` under using [`winscap.exe`](https://github.com/quantum5/winscap)

## Contents

- [`install.ps1`](./install.ps1) - to be run in a `powershell`/`pwsh` shell, installs dependancies % sets up configs
- [`launch.sh`](./launch.sh) - used to launch `cava` and `winscap`
- [`config`](./config) - configuration file for `cava`

## Dependancies

*these will be installed by `install.ps1`*

- `winscap` (in Windows host)
- `cava`
- `git`
- `gh` (sometimes known as `github-cli`)
- `neofetch` (not technically needed but is installed by `install.ps1` anyway)

## Installation

Please make sure WSL is installed and functional, then:

```pwsh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser  # optional: Needed to run a remote script the first time

iex "$( (iwr https://raw.githubusercontent.com/Cornelius-Figgle/cava-wsl/main/install.ps1).Content ) -skip_gh_auth"

wsl -d cava-wsl bash /home/cava/cava-wsl/launch.sh  # start `cava` (assuming default user info)
```

*credit to [SynCap on StackOverflow](https://stackoverflow.com/a/68530475/19860022) and [scoop](https://scoop.sh) for the web script execution code*
