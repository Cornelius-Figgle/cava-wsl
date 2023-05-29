#!/bin/bash

# preq: `wsl --install Debian`
# preq: `wsl --export Debian /v/wsl/Debain.tar`
# preq: `wsl --import cava-wsl ./cava-wsl /v/wsl/Debian.tar`
# preq: `wsl -d cava-wsl -u max bash -c 'cd $HOME; exec bash'`

# preq: `nano ~/token` (paste `gh` access token)

# note: Debian doesn't come with `wget` by default, so remote doesn't work?
# note: copy-paste for now :)

# note: config vars :)
wsl_conf=1

apt_upgrade=1
apt_installs=1

dwld_winscap=1
winscap_path=/mnt/d/winscap.exe

gh_auth=1
token_path=~/token
remove_token=1

git_setup=1
git_name=Cornelius-Figgle
git_email=max@fullimage.net
git_branch=main
git_pull_rebase=false

clone_repo=1
clone_name=~/cava-wsl
link_cfgs=1
cava_cfg_path=~/.config/cava/config
set_prompt=1
bashrc_path=~/.bashrc

# note: consistent working dir
cd ~

# note: create `wsl.conf`
(cat <<- EOF
	[user]
	default = max

	[network]
	hostname = cava-wsl
	generateHosts = false
EOF
) | sudo tee /etc/wsl.conf

# note: install programs
sudo apt update
sudo apt upgrade -y
sudo apt install neofetch cava git gh tmux wget -y

# note: download `winscap` if it doesn't already exist
if [ ! -f /mnt/d/winscap.exe ]; then
	wget -O /mnt/d/winscap.exe  https://github.com/quantum5/winscap/releases/latest/download/winscap.exe
fi

# note: authenticate `gh` and `git`
gh auth login --git-protocol https --with-token < ~/token # note: this will read auth token from file (not the most secure, but I can't think of a better way of doing it)
gh auth setup-git
git config --global user.email max@fullimage.net
git config --global user.name Cornelius-Figgle
git config --global init.defaultBranch main
git config --global pull.rebase false

# note: clone repo with launch scripts & configs
git clone https://github.com/Cornelius-Figgle/cava-wsl.git
cd cava-wsl

# note: symlink config files
mkdir ~/.config/cava
ln -s ~/cava-wsl/config ~/.config/cava/config

# note: set bash prompt
(cat <<- EOF
	
	# note: simplified prompt
	PS1='\w \$ '
EOF
) >> ~/.bashrc

# note: remove token
rm ~/token

# note: reload shell
cd ~
exec bash
clear
