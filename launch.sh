#!/bin/bash

use_tmux=false


if [ ! -e /tmp/cava.fifo ]; then  # note: if no pipe file
    mkfifo /tmp/cava.fifo
fi

if $use_tmux; then
	tmux new -s cava-display -d
	tmux set -g status off

	# note: cava won't render without this
	# info: https://github.com/karlstav/cava/issues/339
	tmux send-keys -t cava-display:0.0 "TERM=xterm-256color" ENTER

	tmux send-keys -t cava-display:0.0 "/mnt/d/winscap.exe 2 48000 16 > /tmp/cava.fifo &" ENTER
	tmux send-keys -t cava-display:0.0 "cava" ENTER

	tmux a
else
	/mnt/d/winscap.exe 2 48000 16 > /tmp/cava.fifo &
	cava
fi
