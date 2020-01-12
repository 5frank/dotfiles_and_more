#!/bin/sh

wifistats()
{
  #watch -n 1 "awk 'NR==3 {print \$3 \"00 %\"}''' /proc/net/wireless"
  #watch -n 1 "awk 'NR==3 {print \$3 \"00 %\"}''' /proc/net/wireless"
  local percent="$(awk 'NR==3 {print $3}' /proc/net/wireless | tr -d .)"
  echo "$percent"
}

wifistats
