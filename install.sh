#!/bin/bash

# preq: `wsl --install Debian`
# preq: `wsl --export Debian /v/wsl/Debain.tar`
# preq: `wsl --import cava-wsl ./cava-wsl /v/wsl/Debian.tar`
# preq: `wsl -d cava-wsl -u max bash -c 'cd $HOME; exec bash'`

# preq: `nano ~/token` (paste `gh` access token)

# note: Debian doesn't come with `wget` by default, so remote doesn't work?
# note: copy-paste for now :)

# ----------------------------------------------------------------------------

# note: config vars
new_hostname="cava-wsl"
wsl_username="max"

winscap_path="/mnt/d/winscap.exe"

token_path="~/token"
remove_token=true

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
sudo apt install neofetch cava git gh tmux wget -y

# note: download `winscap` if it doesn't already exist
if [ ! -f $winscap_path ]; then
	wget -O $winscap_path  https://github.com/quantum5/winscap/releases/latest/download/winscap.exe
fi

# note: authenticate `gh` and `git`
gh auth login --git-protocol https --with-token < $token_path # note: this will read auth token from file (not the most secure, but I can't think of a better way of doing it)
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

if $simplify_prompt; then
	# note: set bash prompt
	(cat <<- EOF

		# note: simplified prompt
		PS1='\w \$ '
	EOF
	) >> $bashrc_path
fi

if $remove_token; then
	# note: remove token
	rm $token_path
fi

# note: reload shell
cd ~
exec bash
clear
