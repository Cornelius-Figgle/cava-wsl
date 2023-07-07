<#
.SYNOPSIS
	A script to automate the creation of a WSL instance for running `cava` in
.DESCRIPTION
	A script to automate the creation of a Debian WSL instance for running `cava` in (via `Winscap`)
.PARAMETER install_location
	Where to import the instance to
.PARAMETER auth_gh
	Whether or not to authenticate a GitHub login (via `gh`)
.PARAMETER use_plaintext_gh_secretkey
	Whether to use a plaintext secretkey instead of an encrypted one (not recomended)
 	Encryption uses `openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:$gh_secretkey_encryption_pass` to decrypt
.PARAMETER gh_secretkey_location
	Location of the secretkey for GitHub authentication
.PARAMETER gh_secretkey_encryption_pass
	Encryption password for GitHub authentication
.PARAMETER git_name
	The name to use when authenticating `git`
.PARAMETER git_email
	The email to use when authenticating `git`
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
	
	[switch]$auth_gh = $false,
	[switch]$use_plaintext_gh_secretkey = $false,
 
	[string]$gh_secretkey_location = $( if ($auth_gh) { Read-Host "Enter secret key path" } ),
	[string]$gh_secretkey_encryption_pass = $( if ($auth_gh -and !$use_plaintext_gh_secretkey) { Read-Host "Enter secret key password" } ),
	[string]$git_name = $(try { git config --global user.name } catch { echo "" }),
	[string]$git_email = $(try { git config --global user.email } catch { echo "" }),
	
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
wsl -d $wsl_hostname -u root apt install -y git gh openssl cava neofetch

# note: download `winscap` if it doesn't already exist
if (!(Test-Path -Path "$install_location\winscap.exe" -PathType Leaf)) {
	Invoke-WebRequest -Uri https://github.com/quantum5/winscap/releases/latest/download/winscap.exe -OutFile "$install_location\winscap.exe"
}

# note: we need to authenticate `gh` to be able to push back (but not for cloning)
if ($auth_gh) {
	# note: authenticate `gh` and setup `git`
	if ($use_plaintext_gh_secretkey) {
		Get-Content $gh_secretkey_location | wsl -d $wsl_hostname -u $wsl_username gh auth login --git-protocol https --with-token
	} else {
  		# info (reguarding pipes): https://craigloewen-msft.github.io/WSLTipsAndTricks/tip/use-pipe-in-one-line-command.html
		Get-Content $gh_secretkey_location | wsl -d $wsl_hostname -u $wsl_username openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:$gh_secretkey_encryption_pass `| gh auth login --git-protocol https --with-token
	}
	wsl -d $wsl_hostname -u $wsl_username gh auth setup-git
	wsl -d $wsl_hostname -u $wsl_username git config --global user.name $git_name
	wsl -d $wsl_hostname -u $wsl_username git config --global user.email $git_email
	wsl -d $wsl_hostname -u $wsl_username git config --global core.autocrlf input
	wsl -d $wsl_hostname -u $wsl_username git config --global init.defaultBranch main
	wsl -d $wsl_hostname -u $wsl_username git config --global pull.rebase false
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
