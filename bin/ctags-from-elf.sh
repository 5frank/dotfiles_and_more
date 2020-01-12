#!/bin/sh
# useful when debugging large source tree where only a small subset
# included in build. 

APP_ELF="$1"

#kudos: https://stackoverflow.com/a/46248192/1565079
APP_SRCS=$(readelf -wi $APP_ELF | grep -B1 DW_AT_comp_dir | \
    awk '/DW_AT_name/{name = $NF; getline; print $NF"/"name}')

# join lines
APP_SRCS=$(echo $APP_SRCS | paste -sd "," -)

ctags $APP_SRCS
