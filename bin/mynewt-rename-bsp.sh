
OLDNAME="$1"
NEWNAME="$2"


rename_suff() 
{
    echo "  mv ${OLDNAME}$1 ${NEWNAME}$1" 
    mv "${OLDNAME}$1" "${NEWNAME}$1" 
}

rename_suff "_debug.sh"  
rename_suff "_debug.cmd"  
rename_suff "_download.sh"  
rename_suff "_download.cmd"
rename_suff ".ld"

#sed -i -e 

sed -i -e "s/${OLDNAME}/${NEWNAME}/g" bsp.yml

