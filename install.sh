# !/bin/bash

# preq: `wsl --install Debian`
# preq: `wsl --export Debian V:\wsl\Debain.tar`
# preq: `wsl --import cava-wsl V:\wsl\cava-wsl V:\wsl\Debian.tar`
# preq: `wsl -d cava-wsl -u max --cd ~`

# note: Debian doesn't come with `wget` by default, so remote doesn't work?
# note: copy-paste for now :)

# ----------------------------------------------------------------------------

# note: config vars
new_hostname="cava-wsl"
wsl_username="max"

winscap_path="/mnt/v/wsl/winscap.exe"

git_name="Cornelius-Figgle"
git_email="max@fullimage.net"

clone_name="~/cava-wsl"
cava_cfg_path="~/.config/cava/config"
simplify_prompt=true
bashrc_path="~/.bashrc"

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
gh auth login --git-protocol https --with-token < $(read -sp "GH Auth Token: " token ; echo $token | openssl passwd -1 -stdin) # note: this will prompt for auth token (should be pasted in)
gh auth setup-git
git config --global user.name $git_name
git config --global user.email $git_email
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
