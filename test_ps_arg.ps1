<#
.SYNOPSIS
	yo??
.DESCRIPTION
	also yyyyyyyyyyyyyo
.PARAMETER install_location
	quite cool
.PARAMETER auth_gh
	also cool
.PARAMETER use_plaintext_gh_secretkey
	not cool at all
.PARAMETER gh_secretkey_location
	very nice
.PARAMETER gh_secretkey_encryption_pass
	also very nice
.PARAMETER git_name
	pants
.PARAMETER git_email
	absolute pants
.PARAMETER wsl_hostname
	meh
.PARAMETER wsl_username
	smells like old boots
.PARAMETER wsl_password
	tastes like concrete
.LINK
	https://github.com/Cornelius-Figgle/cava-wsl
#>

param (
	[string]$install_location = "$env:userprofile\cava-wsl",
	
	[switch]$auth_gh = $false,
	[switch]$use_plaintext_gh_secretkey = $false,

	[string]$gh_secretkey_location = $( if ($auth_gh) { Read-Host "Enter secret key path: " } ),
	[string]$gh_secretkey_encryption_pass = $( if ($auth_gh) { Read-Host "Enter secret key password: " } ),
	[string]$git_name = $(cmd /c "git config --global user.name || (echo."")"),
	[string]$git_email = $(cmd /c "git config --global user.email || (echo."")"),

	[string]$wsl_hostname = "cava-wsl",
	[string]$wsl_username = "cava",
	[string]$wsl_password = "wsl"
)



echo $install_location
echo $skip_gh_auth
echo $use_plaintext_gh_secretkey
echo ""
echo $gh_secretkey_location
echo $gh_secretkey_encryption_pass
echo $git_name
echo $git_email
echo ""
echo $wsl_hostname
echo $wsl_username
echo $wsl_password