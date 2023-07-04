param (
	[string]$install_location = "c:\wsl\cava-wsl",

	[switch]$skip_gh_auth = $true,
	[switch]$use_plaintext_gh_secretkey = $false,

	[string]$gh_secretkey_location = "c:\.secret_vault",
	[string]$gh_secretkey_encryption_pass = "supersecretencryptionpassword",
	[string]$git_name = "Cornelius-Figgle",
	[string]$git_email = "max@fullimage.net",

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