#!/bin/bash

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
wget -O /mnt/d/winscap.exe  https://github.com/quantum5/winscap/releases/latest/download/winscap.exe

gh auth --git-protocol ssh --with-token  # note: this will prompt for auth token
gh auth setup-git
git config --global user.email max@fullimage.net  # note: we setup git even tho we will later overwrite the config file
git config --global user.name Cornelius-Figgle

git clone https://github.com/Cornelius-Figgle/cava-wsl.git
cd cava-wsl

mv ~/.profile /tmp  # note: bin off old files
mv ~/.gitconfig /tmp

if [ -d ~/.config/cava ]; then
    mv ~/.config/cava/config /tmp
else
    mkdir ~/.config/cava
fi

ln -s ~/cava-wsl/.profile ~/.profile
ln -s ~/cava-wsl/config ~/.config/cava/config
ln -s ~/cava-wsl/.gitconfig ~/.gitconfig

(cat <<- EOF
	# note: simplified prompt
	PS1='\w \$'
EOF
) >> ~/.bashrc
