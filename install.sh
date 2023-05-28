#!/bin/bash

# preq: `wsl --install Debian`
# preq: `~/token` containing gh access token
# note: Debian doesn't come with `wget` by default, so remote doesn't work?
# note: copy-paste for now :)

cd ~

(cat <<- EOF
	[network]
	hostname = cava-wsl
	generateHosts = false
EOF
) | sudo tee /etc/wsl.conf

sudo apt update
sudo apt upgrade -y
sudo apt install neofetch cava git gh tmux wget -y

if [ ! -f /mnt/d/winscap.exe ]; then  # note: if no pipe file
    wget -O /mnt/d/winscap.exe  https://github.com/quantum5/winscap/releases/latest/download/winscap.exe
fi

gh auth login --git-protocol https --with-token < ~/token # note: this will prompt for auth token
gh auth setup-git
git config --global user.email max@fullimage.net  # note: we setup git even tho we will later overwrite the config file
git config --global user.name Cornelius-Figgle

git clone https://github.com/Cornelius-Figgle/cava-wsl.git
cd cava-wsl

mv ~/.profile /tmp  # note: bin off old files
mv ~/.gitconfig /tmp
mkdir ~/.config/cava

ln -s ~/cava-wsl/.profile ~/.profile
ln -s ~/cava-wsl/config ~/.config/cava/config
ln -s ~/cava-wsl/.gitconfig ~/.gitconfig

(cat <<- EOF
	# note: simplified prompt
	PS1='\w \$ '
EOF
) >> ~/.bashrc

exec bash
clear
