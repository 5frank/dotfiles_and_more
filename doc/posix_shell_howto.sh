#!/bin/sh

# echo to stderr and exit with error
die() 
{ 
    echo "E: $@" 1>&2; 
    exit 1
}

# accept positive and negative decimal integer values
# kudos: https://unix.stackexchange.com/a/151655
assert_decimal_integer()
{
    local VAL="$1"
    if ! [ "$VAL" -eq "$VAL" ] 2> /dev/null
    then
        echo "'$VAL' is not a decimal integer"
    fi
}

assert_positive_decimal_integer()
{
    local VAL="$1"
    assert_decimal_integer "$VAL"
    if [ "$VAL" -lt "0" ]; then
        echo "'$VAL' is not a positive decimal integer"
    fi
}

assert_decimal_integer "$1"
assert_positive_decimal_integer "$1"
