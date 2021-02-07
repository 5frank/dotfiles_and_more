#!/bin/sh
echoerr() 
{ 
    echo "$@" 1>&2; 
}

ACTIVE_LAYOUT=$(setxkbmap -query | grep layout | grep -oE '[^ ]+$')


setnextlayout()
{
  case "$1" in
    "se") setxkbmap gb ;;
    "gb") setxkbmap se ;;
    *)    
        echoerr "Unknown current layout. setting default" 
        setxkbmap gb
    ;;
  esac
}

## External usb thinkpad keyboard issues
# scancodes from sudo showkey -s,
# xev keycode in parentess
#  | key descr.           | External             | internal x201 |
#  +----------------------+----------------------+---------------+
#  | key above left key   | 0xb8 0xe0 0xcb (113) | 0xe0 0xea
#  | normal left key      | 0xe0 0xcb      (113) | 0xe0 0xcb
#  | key above right key  | 0xb8 0xe0 0xcd       | 0xe0 0xe9
#  | normal right key     | 0xe0 0xcd            | 0xe0 0xcd
#
# lsusb
#  Bus 001 Device 008: ID 17ef:6009 Lenovo ThinkPad Keyboard with TrackPoint


remapkeys()
{
  ## XF86AudoPrev, keycode 173
  xmodmap -e "keycode 173 = Home"

  ## XF86AudoNext, keycode 171
  xmodmap -e "keycode 171 = End"

  ## XF86Forward, keycode 167. X11: PgUp==Next
  xmodmap -e "keycode 167 = Next"
  # on external thinkpad keyboard, right=114
  #xmodmap -e "keycode 114 = Next"

  ## XF86Back, keycode 166. X11: PgDn==Prior
  xmodmap -e "keycode 166 = Prior"
  # on external thinkpad keyboard, left=113
  #xmodmap -e "keycode 113 = Prior"
}


showactive()
{
  local keyboardsymbol='\u2328' # f11c in font awesome
  local activelayout
  case "$1" in
    "se") activelayout="se" ;;
    "gb") activelayout="gb" ;;
    *)    activelayout="??" ;;
  esac
  env printf "$keyboardsymbol%s" "$activelayout"
}

updatei3bar()
{
  # assumes same signal used in i3blocks config
  pkill -RTMIN+10 i3blocks
  #killall -USR1 i3status
}

case "$1" in
  "get")
    echo "$ACTIVE_LAYOUT"
    ;;
  "show")
      showactive $ACTIVE_LAYOUT
    ;;
  "next")
    setnextlayout $ACTIVE_LAYOUT
    #remapkeys
    updatei3bar
    ;;
  "default"|*)
    echo "Setting default"
    setxkbmap gb
    #remapkeys
    updatei3bar
    ;;
esac

# setxkbmap -option caps:ctrl_modifier 



# setxkbmap -query | grep layout
# setxkbmap -query | grep layout | grep -oE '[^ ]+$'
