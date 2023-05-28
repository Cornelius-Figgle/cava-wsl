#!/bin/bash

cd /home/max

sudo apt update
sudo apt upgrade
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
mkdir .config/cava
ln -s /home/max/cava-wsl/.profile /home/max/.profile
ln -s /home/max/cava-wsl/config /home/max/.config/cava/config
ln -s /home/max/cava-wsl/.gitconfig /home/max/.gitconfig
