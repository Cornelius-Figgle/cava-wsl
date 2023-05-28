#!/bin/bash

tmux new -s cava-display -d
tmux send-keys -t cava-display:0.0 "TERM=xterm-256color" ENTER

if [ -f /tmp/cava.fifo ]; then  # note: if no pipe file
    mkfifo /tmp/cava.fifo
fi

tmux send-keys -t cava-display:0.0 "/mnt/d/winscap.exe 2 48000 16 > /tmp/cava.fifo &" ENTER
sleep 1
tmux send-keys -t cava-display:0.0 "cava" ENTER

tmux a
