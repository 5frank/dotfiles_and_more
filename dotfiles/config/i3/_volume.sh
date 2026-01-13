#!/bin/sh

# Volume control etc. refresh  killall -USR1 i3status

_updatei3bar()
{
  # assumes same signal used in i3blocks config
  pkill -RTMIN+10 i3blocks
  #killall -USR1 i3status
}

_printvolume_unicode()
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

_printvolume_fontawesome()
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

_change_vol()
{
    # `5%+` or `5%-` to change up/down 5 percent
    local percent="$1"
    # alt
    # amixer -q set Master $percent unmute 
    wpctl set-volume @DEFAULT_AUDIO_SINK@ $percent

    _updatei3bar
}

#local percents="2"
case "$1" in
  "--up")   _change_vol 2%+;;
  "--down") _change_vol 2%-;;
  "--togglemute") echo "TODO" ;;
  "--show") _printvolume_fontawesome ;;
  *) echo "WAT?" ;;
esac
