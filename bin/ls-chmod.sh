#!/bin/sh
# https://stackoverflow.com/questions/1795976
#find . -printf "%m:%f\n" -maxdepth 1
stat -c '%a %n' *
