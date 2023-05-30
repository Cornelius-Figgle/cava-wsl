# !/bin/bash

# preq: `wsl --install Debian`
# preq: `wsl --export Debian \windows\path\to\Debian.tar`
# preq: `wsl --import cava-wsl \windows\path\to\cava-wsl \windows\path\to\Debian.tar

# note: Debian doesn't come with `wget` by default, so remote doesn't work?
# note: the solution is to save script to host and execute from there
# note: line-endings may have to be changed in Windows before execution
  # info: https://unix.stackexchange.com/a/396553/551787
# preq: `wsl -d cava-wsl -u wsl_username --cd ~ -e bash /mnt/windows/path/to/cava-wsl/install.sh`

# ----------------------------------------------------------------------------

# note: config vars
new_hostname="cava-wsl"
wsl_username="max"

winscap_path="/mnt/v/wsl/winscap.exe"

git_name="Cornelius-Figgle"
git_email="max@fullimage.net"

clone_name="$HOME/cava-wsl"
cava_cfg_path="$HOME/.config/cava/config"
simplify_prompt=true
bashrc_path="$HOME/.bashrc"

# ----------------------------------------------------------------------------

# note: consistent working dir
cd ~

# note: create `wsl.conf`
(cat <<- EOF
	[user]
	default = $wsl_username

	[network]
	hostname = $new_hostname
	generateHosts = false
EOF
) | sudo tee /etc/wsl.conf

# note: install programs
sudo apt update
sudo apt upgrade -y
sudo apt install neofetch cava git gh tmux wget cmatrix openssl -y

# note: download `winscap` if it doesn't already exist
if [ ! -f $winscap_path ]; then
	wget -O $winscap_path  https://github.com/quantum5/winscap/releases/latest/download/winscap.exe
fi

# note: authenticate `gh` and `git`
read -sp "GH Auth Token: " token  # note: this will prompt for auth token (should be pasted in)
echo $token | gh auth login --git-protocol https --with-token
gh auth setup-git
git config --global user.name $git_name
git config --global user.email $git_email
git config --global core.autocrlf input
git config --global init.defaultBranch main
git config --global pull.rebase false

# note: clone repo with launch scripts & configs
git clone https://github.com/Cornelius-Figgle/cava-wsl.git $clone_name
cd $clone_name

# note: symlink config files
mkdir $(dirname $cava_cfg_path)
ln -s $clone_name/$(basename $cava_cfg_path) $cava_cfg_path

# note: set bash prompt
if $simplify_prompt; then
	(cat <<- EOF

		# note: simplified prompt
		PS1='\w \$ '
	EOF
	) >> $bashrc_path
fi

# note: reload shell
cd ~
exec bash
clear
