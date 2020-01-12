#!/bin/sh

U_BATTERY='\u1f50b'
U_STAR='\u2388'
U_PLUG='\uf1e6'
U_KEYBOARD='\u2328'
U_ELECTRIC_ARROW='\u2301'
U_HORI_BLOCK='\u25AC'
#U_VERT_BLOCK='\u25AE'
#U_VERT_BLOCK='\u258A'
U_VERT_BLOCK='\u2580'

printBatteryStatus_unicode()
{
  local acstatus="$1"
  local percent="$2" # "$(echo $2 | tr -d %)"
  local baticon='?'

  case "$acstatus" in
    *on-line)
      baticon="$U_PLUG"
    ;;

    *off-line)
      baticon='\u2580' # vertical block U_BATTERY='\u1f50b' if supported
    ;;

    *)
      baticon='?'
    ;;
  esac

  #echo "$baticon $percent"
  env printf "$baticon%3d%%" "$percent"
}

printBatteryStatus_fontawesome()
{
  local acstatus="$1"
  local percent="$2" # "$(echo $2 | tr -d %)"
  local baticon='?'

  case "$acstatus" in
    *on-line)
      baticon="$U_PLUG"
    ;;
    *off-line)
      # these battery symbols requre fonts-font-awesome > v4.4
      # debian jessie stable have v4.2. install from sid.
      if [ "$percent" -lt 20 ]; then
        baticon='\uf244' #  fa-battery-0 / fa-battery-empty
      elif [ "$percent" -lt 40 ]; then
        baticon='\uf243' #  fa-battery-1 /  fa-battery-quarter
      elif [ "$percent" -lt 60 ]; then
        baticon='\uf242' # fa-battery-2 /  fa-battery-half
      elif [ "$percent" -lt 80 ]; then
        baticon='\uf241' #
      elif [ "$percent" -lt 101 ]; then
        baticon='\uf240'
      else
        baticon='?'
      fi
    ;;
    *)
      baticon='?'
    ;;
  esac

  #echo "$baticon $percent"
  env printf "$baticon%3d%%" "$percent"
}

AC_STATUS=$(acpi --ac-adapter)
# Output of acpi --battery is either:
#  when ac off-line: Battery 0: Discharging, 99%, 03:16:32 remaining
#  when ac on-line:  Battery 0: Unknown, 99%
BAT_PERCENT=$(acpi --battery | grep -o '[^ ]*%' | tr -d %)

#echo $BATTERY_PERCENT

printBatteryStatus_fontawesome "$AC_STATUS" "$BAT_PERCENT"
