#!/bin/bash

# TODO use /sys/class/drm/<display>/dpms or /enabled for display state!?
# example 
# cd /sys/class/drm && grep "^connected" */status
# cd /sys/class/drm && grep "^On" */dpms

turn_off_displays()
{
    local displaylist="$1"
    echo "$1" | while read -r displ; do
        xrandr --output "${displ}" --off
    done
    #<<< "$displaylist"

}

set_next_display_primary()
{
    local connected active newdispl primary

    connected=$(xrandr | grep " connected ")
    
    # this will probably break. match resolution likke 1024x768 etc
    # output could be `LVDS-1 primary 1024x768+...` or `LVDS-1 connected primary 1024x768+...'
    active=$(echo "${connected}" | grep -E "([0-9]{2,5})x([0-9]{2,5})*.*" | head -1 | awk '{print $1;}')
    primary=$(echo "${connected}" | grep "primary" | awk '{print $1;}')

    echo "active:\"${active}\" new:\"${newdispl}\""

    local numactive=$(echo "${active}" | wc -l)
    if [ "${numactive}" -gt 1 ]; then
        turn_off_displays "${active}" 
        xrandr --output "${primary}" --auto  # only wnat one monitor enabled
        exit 1
    fi

    if [ -z  "${active}" ]; then
        xrandr --output "${primary}" --auto  # only wnat one monitor enabled
        exit 0
    fi

    newdispl=$(echo "${connected}" | grep -v "${active}" | head -1 | awk '{print $1;}')
    if [ -z  "${newdispl}" ]; then 
        exit 0
    fi

    if [ "${newdispl}" = "${active}" ]; then
        exit 0
    fi

    # setting --primary mess things up    
    xrandr --output "${newdispl}" --auto --output ${active} --off
}

set_next_display_primary
exit 0

EXTERNAL_OUTPUT="HDMI-2"
INTERNAL_OUTPUT="LVDS1"

CONNECTED_DISPLAYS=$(xrandr | grep " connected ")

PRIMARY_DISPLAY=$(echo "$CONNECTED_DISPLAYS" | grep "primary" | awk '{print $1;}')
EXTERNAL_DISPLAY=$(echo "$CONNECTED_DISPLAYS" | grep -v "primary" | awk '{print $1;}')




# xrandr | grep " connected" | awk '{print $1;}'

#echo $CONNECTED_DISPLAYS
#echo $PRIMARY_DISPLAY
#echo $EXTERNAL_DISPLAY

NUM_EXTERNAL=$(echo "$EXTERNAL_DISPLAY" | wc -w)

if [ "$NUM_EXTERNAL" -eq "1" ]; then
  echo "Switching $EXTERNAL_DISPLAY (external display)"
  xrandr --output "$PRIMARY_DISPLAY" --off --output $EXTERNAL_OUTPUT --auto
elif [ "$NUM_EXTERNAL" -eq "0" ]; then
  echo "Switching to $PRIMARY_DISPLAY (internal primary display)"
  xrandr --output "$PRIMARY_DISPLAY" --auto --output $EXTERNAL_OUTPUT --off
  #xrandr --output "$PRIMARY_DISPLAY" --mode 1280x800 
else
  echo "E: Failed. xrandr greped output: $CONNECTED_DISPLAYS"
fi
#        xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --off
#        xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --same-as $INTERNAL_OUTPUT

# xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --left-of $INTERNAL_OUTPUT

#xrandr --output LVDS1 --off --output VGA1 --auto
