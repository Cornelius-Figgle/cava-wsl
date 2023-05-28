#!/bin/bash

#tmux new -s cava-display -d

#tmux send-keys -t cava-display:0.0 "rm /tmp/cava.fifo" ENTER

#tmux send-keys -t cava-display:0.0 "mkfifo /tmp/cava.fifo" ENTER

#tmux send-keys -t cava-display:0.0 "/mnt/d/winscap.exe 2 48000 16 > /tmp/cava.fifo &" ENTER

#tmux send-keys -t cava-display:0.0 "cava" ENTER

#tmux a

rm /tmp/cava.fifo

mkfifo /tmp/cava.fifo

/mnt/d/winscap.exe 2 48000 16 > /tmp/cava.fifo &

cava
