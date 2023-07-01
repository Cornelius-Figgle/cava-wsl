# title: automated WSL container creation for running `cava` in

$install_location = "v:\wsl\cava-wsl"

$use_encrypted_gh_secretkey = $true
$gh_secretkey_location = "v:\.secret_vault"
$gh_secretkey_encryption_pass = "supersecretencryptionpassword"
$git_name = "Cornelius-Figgle"
$git_email = "max@fullimage.net"

$wsl_hostname = "cava-wsl"
$wsl_username = "cava"
$wsl_password = "wsl"


# note: if instance doesn't already exist
$env:WSL_UTF8 = 1  # info: https://stackoverflow.com/questions/72764797/how-to-ask-wsl-to-check-if-the-distribution-exists-using-bash-and-wsl-exe
if ( (wsl -l -q | out-string -stream | select-string cava-wsl) ) {
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

# note: authenticate `gh` and setup `git`
if ($use_encrypted_gh_secretkey -eq $true) {
	# info (reguarding pipes): https://craigloewen-msft.github.io/WSLTipsAndTricks/tip/use-pipe-in-one-line-command.html
	Get-Content $gh_secretkey_location | wsl -d $wsl_hostname -u $wsl_username openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:$gh_secretkey_encryption_pass `| gh auth login --git-protocol https --with-token
} else {
	Get-Content $gh_secretkey_location | wsl -d $wsl_hostname -u $wsl_username gh auth login --git-protocol https --with-token
}
wsl -d $wsl_hostname -u $wsl_username gh auth setup-git
wsl -d $wsl_hostname -u $wsl_username git config --global user.name $git_name
wsl -d $wsl_hostname -u $wsl_username git config --global user.email $git_email
wsl -d $wsl_hostname -u $wsl_username git config --global core.autocrlf input
wsl -d $wsl_hostname -u $wsl_username git config --global init.defaultBranch main
wsl -d $wsl_hostname -u $wsl_username git config --global pull.rebase false

# note: git clone the project files
wsl -d $wsl_hostname -u $wsl_username git clone https://github.com/Cornelius-Figgle/cava-wsl.git "/home/$wsl_username/$wsl_hostname"

# note: symlink configs for `cava`
wsl -d $wsl_hostname -u $wsl_username mkdir -p "/home/$wsl_username/.config/cava"
wsl -d $wsl_hostname -u $wsl_username ln -s "/home/$wsl_username/$wsl_hostname/config" "/home/$wsl_username/.config/cava/config"
wsl -d $wsl_hostname -u $wsl_username mv "/home/$wsl_username/.profile" "/tmp"
wsl -d $wsl_hostname -u $wsl_username ln -s "/home/$wsl_username/$wsl_hostname/.profile" "/home/$wsl_username/.profile"
