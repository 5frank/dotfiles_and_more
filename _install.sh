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
            #echo "ignoring $SCRIPT_NAME"
            bname=$(basename $shfile .sh)
            local dest="$HOME/bin/$bname"
            echo "$dest"
            cp --no-clobber $shfile $dest
            chmod +x $dest
        fi
        #basename
    done
}
move_to_home "$@"
