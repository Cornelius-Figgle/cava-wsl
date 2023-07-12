#!/bin/bash

# note: equivalent to `$env:userprofile\cava-wsl`
# info: https://superuser.com/a/1391349/1727228
install_location=${1:-"$(wslpath $(cmd.exe /C "echo | set /p _=%USERPROFILE%"))/cava-wsl"}

if [ ! -e /tmp/cava.fifo ]; then  # note: if no pipe file
	mkfifo /tmp/cava.fifo
fi

"$install_location/winscap.exe" 2 48000 16 > /tmp/cava.fifo &
cava
