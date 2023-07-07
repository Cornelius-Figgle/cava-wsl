# cava-wsl

dotfiles & install scripts for a Debian WSL instance that I run `cava` under using [`winscap.exe`](https://github.com/quantum5/winscap)

## Contents

- [`install.ps1`](./install.ps1) - to be run in a `powershell`/`pwsh` shell, installs dependancies % sets up configs
- [`launch.sh`](./launch.sh) - used to launch `cava` and `winscap`
- [`config`](./config) - configuration file for `cava`
- [`.profile`](./.profile) - configuration file for `bash` (see [here](https://github.com/microsoft/WSL/issues/2067) for more info)

## Dependancies

*these will be installed by `install.ps1`*

- `winscap` (in Windows host)
- `cava`
- `git`
- `gh` (sometimes known as `github-cli`)
- `neofetch` (not technically needed but is installed by `install.ps1` anyway)

## Installation

Please make sure WSL is [installed and functional](https://learn.microsoft.com/en-us/windows/wsl/install), then:

```pwsh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser  # optional: Needed to run a remote script the first time

& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Cornelius-Figgle/cava-wsl/main/install.ps1")))

wsl -d cava-wsl bash /home/cava/cava-wsl/launch.sh  # start `cava` (assuming default user info)
```

*credit to [Mathias R. Jessen on StackOverflow](https://stackoverflow.com/a/68530475/19860022) for the web script execution code*

## Usage


