#!/bin/bash

install_location="/mnt/v/wsl/cava-wsl"

if [ ! -e /tmp/cava.fifo ]; then  # note: if no pipe file
	mkfifo /tmp/cava.fifo
fi

"$install_location/winscap.exe" 2 48000 16 > /tmp/cava.fifo &
cava
