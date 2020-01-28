#!/bin/sh

# Volume control etc. refresh  killall -USR1 i3status

updatei3bar()
{
  # assumes same signal used in i3blocks config
  pkill -RTMIN+10 i3blocks
  #killall -USR1 i3status
}

printvolume_unicode()
{
  # get evertyning within brackets
  local chstatus="$(amixer get Master | grep -oE '\[(.*?)\]' | tr -d []%)"
  # take the left channel
  local percentl="$(echo $chstatus | awk '{print $1;}')"
  #local percentr="$(echo $chstatus | awk '{print $3;}')"
  local percent="$percentl"
  # if any channel is on - display as unmuted
  case "$chstatus" in
    *on*)  volumeicon='\u1F50A';; # Speaker with Three Sound Waves
    *off*) volumeicon='\u1F507';; # Speaker with Cancellation Stroke
    *)     volumeicon='?';;
  esac

  env printf "$volumeicon%3d%%" "$percent"
}

printvolume_fontawesome()
{
  # get evertyning within brackets
  local chstatus="$(amixer get Master | grep -oE '\[(.*?)\]' | tr -d []%)"
  # take the left channel
  local percentl="$(echo $chstatus | awk '{print $1;}')"
  #local percentr="$(echo $chstatus | awk '{print $3;}')"
  local percent="$percentl"
  # if any channel is on - display as unmuted
  case "$chstatus" in
    *on*)  volumeicon='\uF028';; # fa-volume-up
    *off*) volumeicon='\uF026';; # fa-volume-off
    *)     volumeicon='?';;
  esac

  #echo "$volumeicon"
  env printf "$volumeicon%3d%%" "$percent"
}


#local percents="2"
case "$1" in
  "up")   amixer -q set Master 2%+ unmute && updatei3bar;;
  "down") amixer -q set Master 2%- unmute && updatei3bar;;
  "togglemute") echo "TODO" ;;
  "show") printvolume_fontawesome ;;
  *) echo "WAT?" ;;
esac
