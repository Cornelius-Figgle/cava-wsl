#!/bin/bash

# preq: `wsl --install Debian`
# preq: `wsl --export Debian /v/wsl/Debain.tar`
# preq: `wsl --import cava-wsl ./cava-wsl /v/wsl/Debian.tar`
# preq: `wsl -d cava-wsl -u max bash -c 'cd $HOME; exec bash'`

# preq: `nano ~/token` (paste gh access token)
# note: Debian doesn't come with `wget` by default, so remote doesn't work?
# note: copy-paste for now :)

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
# note: we setup git even tho we will later overwrite the config file
gh auth login --git-protocol https --with-token < ~/token # note: this will read auth token from file (not the most secure, but I can't think of a better way of doing it)
gh auth setup-git
git config --global user.email max@fullimage.net
git config --global user.name Cornelius-Figgle

# note: clone repo with launch scripts & configs
git clone https://github.com/Cornelius-Figgle/cava-wsl.git
cd cava-wsl

# note: bin off old files
mv ~/.gitconfig /tmp
mkdir ~/.config/cava

ln -s ~/cava-wsl/config ~/.config/cava/config
ln -s ~/cava-wsl/.gitconfig ~/.gitconfig

# note: set bash prompt
(cat <<- EOF
	
	# note: simplified prompt
	PS1='\w \$ '
EOF
) >> ~/.bashrc

# note: remove token
rm ~/token

# note: reload shell
exec bash
clear
