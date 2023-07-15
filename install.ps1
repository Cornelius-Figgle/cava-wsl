<#
.SYNOPSIS
	A script to automate the creation of a WSL instance for running `cava` in
.DESCRIPTION
	A script to automate the creation of a Debian WSL instance for running `cava` in (via `Winscap`)
.PARAMETER install_location
	Where to import the instance to
.PARAMETER cava_config_location
	Config file to use for `cava`
.PARAMETER force_redownload
	Redownload the initial TAR instead of using a previously downloaded one
.PARAMETER wsl_hostname
	The hostname to use for the instance
.PARAMETER wsl_username
	The username to use for the instance
.PARAMETER wsl_password
	The password to use for the instance
.LINK
	https://github.com/Cornelius-Figgle/cava-wsl
#>

# argument handling
param (
	[string]$install_location = "$env:userprofile\cava-wsl",
 	[string]$cava_config_location,

  	[switch]$force_redownload = $false,
	
	[string]$wsl_hostname = "cava-wsl",
	[string]$wsl_username = "cava",
	[string]$wsl_password = "wsl"
)


# exit if instance already exists
$env:WSL_UTF8=1  # https://stackoverflow.com/questions/72764797/how-to-ask-wsl-to-check-if-the-distribution-exists-using-bash-and-wsl-exe
if ( (wsl -l -q | out-string -stream | select-string $wsl_hostname) ) {
	exit 2
}

# download tarball if it doesn't already exist
if (!(Test-Path -Path "$env:TEMP\Debian-NO_USER.tar" -PathType Leaf) -or $force_redownload) {
	Invoke-WebRequest -Uri https://github.com/Cornelius-Figgle/cava-wsl/releases/latest/download/Debian-NO_USER.tar -OutFile "$env:TEMP\Debian-NO_USER.tar"
}
wsl --import $wsl_hostname $install_location "$env:TEMP\Debian-NO_USER.tar"
wsl -d $wsl_hostname -u root useradd --create-home --user-group --groups  adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev --password $wsl_password $wsl_username

# WSL config for hostname & default user
$wsl_config = @"
[user]
default = $wsl_username

[network]
hostname = $wsl_hostname
generateHosts = false
"@
wsl -d $wsl_hostname -u root echo $wsl_config `> /etc/wsl.conf  # we write via WSL to preserve UNIX format

# install programs into instance
wsl -d $wsl_hostname -u root apt update
wsl -d $wsl_hostname -u root apt upgrade -y
wsl -d $wsl_hostname -u root apt install -y git cava crudini neofetch

# git clone the project files
wsl -d $wsl_hostname -u $wsl_username git clone https://github.com/Cornelius-Figgle/cava-wsl.git "/home/$wsl_username/cava-wsl"

# download `winscap` into instance
$winscap_path = $(wsl -d $wsl_hostname -u $wsl_username wslpath -w "/opt/winscap.exe")
Invoke-WebRequest -Uri https://github.com/quantum5/winscap/releases/latest/download/winscap.exe -OutFile $winscap_path
wsl -d $wsl_hostname -u root chmod 755 /opt/winscap.exe
wsl -d $wsl_hostname -u root chown $wsl_username`:$wsl_username /opt/winscap.exe

# symlink configs for `cava`
wsl -d $wsl_hostname -u $wsl_username mkdir -p "/home/$wsl_username/.config/cava"
if (($cava_config_location) -and (Test-Path -Path "$cava_config_location" -PathType Leaf)) {  # if the path is valid
	$cava_config_location = $(wsl -d $wsl_hostname -u $wsl_username wslpath $("'"+$cava_config_location+"'"))
} else {
	$cava_config_location = "/home/$wsl_username/cava-wsl/default_cava_config"  # use our default config
}
wsl -d $wsl_hostname -u $wsl_username ln -s  $cava_config_location "/home/$wsl_username/.config/cava/config"
wsl -d $wsl_hostname -u $wsl_username mv "/home/$wsl_username/.profile" "/tmp"
wsl -d $wsl_hostname -u $wsl_username ln -s "/home/$wsl_username/cava-wsl/.profile" "/home/$wsl_username/.profile"

# restart
wsl -d $wsl_hostname --shutdown
