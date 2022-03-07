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

print_battatus_unicode()
{
    local acstatus="$1"
    local percent="$2" # "$(echo $2 | tr -d %)"
    local baticon='?'

    case "$acstatus" in
        1)
            baticon="$U_PLUG"
        ;;

        0)
            baticon='\u2580' # vertical block U_BATTERY='\u1f50b' if supported
        ;;

        *)
            baticon='?'
        ;;
    esac

    #echo "$baticon $percent"
    env printf "$baticon%3d%%" "$percent"
}

print_batstatus_fontawesome()
{
    local acstatus="$1"
    local percent="$2" # "$(echo $2 | tr -d %)"
    local baticon='?'

    case "$acstatus" in
        1)
            baticon="$U_PLUG"
        ;;

        0)
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

_get_acstatus_from_acpi()
{
    # Output of acpi --battery is either:
    #  when ac off-line: Battery 0: Discharging, 99%, 03:16:32 remaining
    #  when ac on-line:  Battery 0: Unknown, 99%

    local acstatus==$(acpi --ac-adapter)

    case "$acstatus" in
        *on-line)
            echo "1"
        ;;
        *off-line)
            echo "0"
        ;;
        *)
            echo "?"
        ;;
    esac
}

_get_batlevel_from_acpi()
{
    local batno="$1"
    local percent=$(acpi --battery | grep "Battery $batno" | grep -o '[^ ]*%' | tr -d %)
    echo "$percent"
}

_get_acstatus_from_sys()
{
    cat "/sys/class/power_supply/AC/online"
}

_get_batlevel_from_sys()
{
    local batno="$1"

    local base_path="/sys/class/power_supply/BAT$batno"
    local energy_now=$(cat "$base_path/energy_now")
    local energy_full=$(cat "$base_path/energy_full")

    # dual parentesis to eval math expression
    local percent=$(((100*$energy_now)/$energy_full))
    echo "$percent"
}

ACSTATUS=$(_get_acstatus_from_sys)

BAT0_PERCENT=$(_get_batlevel_from_acpi "0")
BAT1_PERCENT=$(_get_batlevel_from_acpi "1")


print_batstatus_fontawesome "$ACSTATUS" "$BAT0_PERCENT"
print_batstatus_fontawesome "$ACSTATUS" "$BAT1_PERCENT"
