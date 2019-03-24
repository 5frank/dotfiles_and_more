#!/bin/sh
#nmap -sP 192.168.1.* | grep report | sed "s/^Nmap scan report for //" | awk '{ print $2 " " $1}'
#nmap -sP 192.168.1.* | grep report | tr -d '()' | sed "s/^Nmap scan report for //" | awk '{if ($2) print $2 "  " $1; else print $1 "  " "-";}'

nmap_scan_range()
{
    local ipv4addr="$1"
    
    echo "nmap -sn $ipv4addr"

    #In older versions of Nmap, -sn was known as -sP.
    nmap -sn -R $ipv4addr \
        | grep "report" \
        | tr -d '()' \
        | sed "s/^Nmap scan report for //" \
        | column -t 
}

scan_lan_devices() 
{
    local ipv4addr
    local ifname="$1"
    if [ ! -z "$ifname" ]; then

        for devpath in "/sys/class/net/$ifname"; do
            local ifdev=$(basename $devpath)
            ipv4addr=$(ip -4 addr show dev $ifdev \
                | grep -oP "(?<=inet ).*(?=/)")
            ipv4addr="${ipv4addr%.*}.*" # replace last digits after dot with *
            echo "---- interface: $ifdev ($ipv4addr) ----"
            nmap_scan_range $ipv4addr
        done
    else
        ipv4addr=$(ip route get 1 \
            | awk '{print $NF;exit}' \
            | grep -Po '.*(?=\.)')
        #remove last dot and digits
        ipv4addr="${ipv4addr%.*}.*" # replace last digits after dot with *
        nmap_scan_range $ipv4addr
    fi


}


scan_lan_devices "$@"
