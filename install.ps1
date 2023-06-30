# automated WSL container creation for running `cava` in

$install_location = "v:\wsl\cava-wsl"

$use_encrypted_gh_secretkey = $true
$gh_secretkey_location = "v:\.secret_vault"
$gh_secretkey_encryption_pass = "supersecretencryptionpassword"
$git_name = "Cornelius-Figgle"
$git_email = "max@fullimage.net"

$wsl_hostname = "cava-wsl"
$wsl_username = "cava"
$wsl_password = "wsl"

$simplify_prompt = $true


Invoke-WebRequest -Uri https://github.com/Cornelius-Figgle/cava-wsl/releases/latest/download/Debian-NO_USER.tar -OutFile $env:TEMP\Debian-NO_USER.tar
wsl --import $wsl_hostname $install_location $env:TEMP\Debian-NO_USER.tar
wsl -d $wsl_hostname -u root useradd --create-home --user-group --groups  adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev --password $wsl_password $wsl_username

$wsl_config = @"
[user]
default = $wsl_username

[network]
hostname = $wsl_hostname
generateHosts = false
"@
wsl -d $wsl_hostname -u root -e $wsl_config > /etc/wsl.conf  # note: we write via WSL to preserve UNIX format

wsl -d $wsl_hostname -u root -e apt update
wsl -d $wsl_hostname -u root -e apt upgrade -y
wsl -d $wsl_hostname -u root -e  apt install -y git gh openssl cava neofetch

Invoke-WebRequest -Uri https://github.com/quantum5/winscap/releases/latest/download/winscap.exe -OutFile $install_location\winscap.exe

if ($use_encrypted_gh_secretkey -eq $true) {
	$encrypted_gh_secretkey = Get-Content $gh_secretkey_location
 	wsl -d $wsl_hostname -u $wsl_username -e echo $encrypted_gh_secretkey | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:$gh_secretkey_encryption_pass | gh auth login --git-protocol https --with-token
} else {
	wsl -d $wsl_hostname -u $wsl_username -e bash 
}
