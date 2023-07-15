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
- [`crudini`](https://www.pixelbeat.org/programs/crudini/) (for input changing on config file)
- `neofetch` (not technically needed but is installed by `install.ps1` anyway)

## Installation

Please make sure WSL is [installed and functional](https://learn.microsoft.com/en-us/windows/wsl/install), then:

```pwsh
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Cornelius-Figgle/cava-wsl/main/install.ps1")))

wsl -d cava-wsl bash /home/cava/cava-wsl/launch.sh  # starts `cava` (assuming default user info)
```

*credit to [Mathias R. Jessen on StackOverflow](https://stackoverflow.com/a/68530475/19860022) for the web script execution code*

## Usage

```pwsh
$ Get-Help .\install.ps1 -Detailed

NAME
    & $([scriptblock]::Create((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Cornelius-Figgle/cava-wsl/main/install.ps1")))

SYNOPSIS
    A script to automate the creation of a WSL instance for running `cava` in

SYNTAX
    install.ps1 [[-install_location] <String>]
    [[-cava_config_location] <String>] [-force_redownload] [[-wsl_hostname] <String>]
    [[-wsl_username] <String>] [[-wsl_password] <String>] [<CommonParameters>]

DESCRIPTION
    A script to automate the creation of a Debian WSL instance for running `cava` in (via `Winscap`)

PARAMETERS
    -install_location <String>
        Where to import the instance to

    -cava_config_location <String>
        Config file to use for `cava`

    -force_redownload [<SwitchParameter>]
        Redownload the initial TAR instead of using a previously downloaded one

    -wsl_hostname <String>
        The hostname to use for the instance

    -wsl_username <String>
        The username to use for the instance

    -wsl_password <String>
        The password to use for the instance

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).
```
