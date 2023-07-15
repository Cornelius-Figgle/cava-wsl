#!/bin/bash

if [ ! -e /tmp/cava.fifo ]; then  # note: if no pipe file
	mkfifo /tmp/cava.fifo
fi

rm /tmp/cava.conf
cp -H ~/.config/cava/config /tmp/cava.conf
echo "
[input]
method = fifo
source = /tmp/cava.fifo
sample_rate = 48000" | crudini --merge /tmp/cava.conf

"/opt/winscap.exe" 2 48000 16 > /tmp/cava.fifo &
cava -p "/tmp/cava.conf"
