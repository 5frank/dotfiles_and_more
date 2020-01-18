#!/bin/sh


#shopt -s nullglob

SCRIPT_NAME=$(basename "$0")
move_to_home()
{
    mkdir -p "$HOME/bin/"

    local bname;
    for shfile in "$@"; do

        bname=$(basename $shfile)
        if [ ! "$bname" = "$SCRIPT_NAME" ]; then
            local cmdname=${bname%.*} # remove suffix
            local dest="$HOME/bin/$cmdname"
            echo "$dest"
            cp -i $shfile $dest
            chmod +x $dest
        fi
    done
}

move_to_home "$@"


