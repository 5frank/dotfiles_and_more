#!/bin/sh

die() 
{ 
    echo "E: $@" 1>&2
    exit 1
}

assert_digit()
{
    local num="$1"
    if [ -z "${num##*[!0-9]*}" ]; then 
        die "Not a number"
    fi
}

#TODO 
# = use all columns if no args
# flags to set column
awk_column_sum()
{
    local field="$1"
    assert_digit $field
    local catsrc;

    # kudos: https://stackoverflow.com/a/46726373/1565079
    # Check to see if a pipe exists on stdin.
    if [ -p /dev/stdin ]; then
        # If we want to read the input line by line
        #while IFS= read line; do
        #        echo "Line: ${line}"
        #done
        catsrc="-" # e.g. stdin

    else
        local filesrc="$2"
        if [ -f "$filesrc" ]; then
            catsrc=$filesrc
        else
            die "No input" 
        fi
    fi

    cat $catsrc | awk -v sumfield="$field" '{sum+=$sumfield} END {print sum}'
}

awk_column_sum "$@"
