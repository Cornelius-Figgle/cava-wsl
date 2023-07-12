#!/bin/bash

# note: equivalent to `$env:userprofile\cava-wsl`
# info: https://superuser.com/a/1391349/1727228
install_location=$(wslpath {1:-$(cmd.exe /C "echo | set /p _=%USERPROFILE%")\\cava-wsl})

if [ ! -e /tmp/cava.fifo ]; then  # note: if no pipe file
	mkfifo /tmp/cava.fifo
fi

cat > "~/.config/cava/config" <<- EOF
[input]
method = fifo
source = /tmp/cava.fifo
sample_rate = 48000
EOF 

"$install_location/winscap.exe" 2 48000 16 > /tmp/cava.fifo &
cava
