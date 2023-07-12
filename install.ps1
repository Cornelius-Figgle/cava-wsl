<#
.SYNOPSIS
	A script to automate the creation of a WSL instance for running `cava` in
.DESCRIPTION
	A script to automate the creation of a Debian WSL instance for running `cava` in (via `Winscap`)
.PARAMETER install_location
	Where to import the instance to
.PARAMETER wsl_hostname
	The hostname to use for the instance
.PARAMETER wsl_username
	The username to use for the instance
.PARAMETER wsl_password
	The password to use for the instance
.LINK
	https://github.com/Cornelius-Figgle/cava-wsl
#>

# note: argument handling
param (
	[string]$install_location = "$env:userprofile\cava-wsl",
	
	[string]$wsl_hostname = "cava-wsl",
	[string]$wsl_username = "cava",
	[string]$wsl_password = "wsl"
)


# note: exit if instance already exists
$env:WSL_UTF8=1  # info: https://stackoverflow.com/questions/72764797/how-to-ask-wsl-to-check-if-the-distribution-exists-using-bash-and-wsl-exe
if ( (wsl -l -q | out-string -stream | select-string $wsl_hostname) ) {
	exit 2
}

# note: download tarball if it doesn't already exist
if (!(Test-Path -Path "$env:TEMP\Debian-NO_USER.tar" -PathType Leaf)) {
	Invoke-WebRequest -Uri https://github.com/Cornelius-Figgle/cava-wsl/releases/latest/download/Debian-NO_USER.tar -OutFile "$env:TEMP\Debian-NO_USER.tar"
}
wsl --import $wsl_hostname $install_location "$env:TEMP\Debian-NO_USER.tar"
wsl -d $wsl_hostname -u root useradd --create-home --user-group --groups  adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev --password $wsl_password $wsl_username

# note: WSL config for hostname & default user
$wsl_config = @"
[user]
default = $wsl_username

[network]
hostname = $wsl_hostname
generateHosts = false
"@
wsl -d $wsl_hostname -u root echo $wsl_config `> /etc/wsl.conf  # note: we write via WSL to preserve UNIX format

# note: install `git` & `cava`
wsl -d $wsl_hostname -u root apt update
wsl -d $wsl_hostname -u root apt upgrade -y
wsl -d $wsl_hostname -u root apt install -y git cava neofetch

# note: download `winscap` if it doesn't already exist
if (!(Test-Path -Path "$install_location\winscap.exe" -PathType Leaf)) {
	Invoke-WebRequest -Uri https://github.com/quantum5/winscap/releases/latest/download/winscap.exe -OutFile "$install_location\winscap.exe"
}

# note: git clone the project files
wsl -d $wsl_hostname -u $wsl_username git clone https://github.com/Cornelius-Figgle/cava-wsl.git "/home/$wsl_username/$wsl_hostname"

# note: symlink configs for `cava`
wsl -d $wsl_hostname -u $wsl_username mkdir -p "/home/$wsl_username/.config/cava"
wsl -d $wsl_hostname -u $wsl_username ln -s "/home/$wsl_username/$wsl_hostname/config" "/home/$wsl_username/.config/cava/config"
wsl -d $wsl_hostname -u $wsl_username mv "/home/$wsl_username/.profile" "/tmp"
wsl -d $wsl_hostname -u $wsl_username ln -s "/home/$wsl_username/$wsl_hostname/.profile" "/home/$wsl_username/.profile"

# note: restart
wsl -d $wsl_hostname --shutdown
