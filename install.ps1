# `wsl --install -d Debian`
# ctrl-c
# `wsl --export Debian /v/wsl/Debian-NO_USER.tar`
# `wsl -d Debian -u root useradd --create-home --user-group --groups  adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev --password "password" max`

wsl --import cava-wsl /v/wsl/cava-wsl /v/wsl/Debian-NO_USER.tar
wsl -d cava-wsl -u root useradd --create-home --user-group --groups  adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,netdev --password "wsl" cava
