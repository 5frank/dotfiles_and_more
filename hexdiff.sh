#!/bin/sh

usage()
{
    echo "hexdiff FILE1 FILE2 [diffprog]"
}

hexdiff()
{
    local binfile1="$1"
    local binfile2="$2"
    local diffprog="$3"
    if [ -z "$diffprog" ]; then
        diffprog="diff"
    fi
    if [ ! -e "$binfile1" ]; then
        echo "E: No such file '$binfile1'" 
        exit 1
    fi

    if [ ! -e "$binfile2" ]; then
        echo "E: No such file '$binfile2'" 
        exit 1
    fi

    local bname1=$(basename "$binfile1")
    local bname2=$(basename "$binfile2")

    local tmphexdump1=$(mktemp -t ${bname1}.hexdiff.tmp.XXXXXXXXXX)
    local tmphexdump2=$(mktemp -t ${bname2}.hexdiff.tmp.XXXXXXXXXX)

    hexdump -C "$binfile1" > $tmphexdump1
    hexdump -C "$binfile2" > $tmphexdump2
    $diffprog $tmphexdump1 $tmphexdump2

    rm -f $tmphexdump1 $tmphexdump2
    return

}


hexdiff "$@"
