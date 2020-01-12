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
            local cmdname=${bname%.*} # remove suffix
            local dest="$HOME/bin/$cmdname"
            echo "$dest"
            cp -i $shfile $dest
            chmod +x $dest
        fi
        #basename
    done
}

if [ "$1" = "all" ]; then
move_to_home \
    bits.py \
    lsserial.py  \
    pdftoascii.sh \
    encode-mp3-cbr320.sh \
    hexdiff.sh \
    ls-lan.sh \
    ctags-from-elf.sh \
    git-branches-by-commit-date.sh \
    git-anonymise-origin.sh 
else 
    move_to_home "$@"
fi

