#!/bin/sh 
                
# commands that show metadata:
#
#  mdls path/file.extension
#  xattr path/file.extension
#  ls -l@ path/file.extension
#  exiftool  <file>
#    avaialbe in the debian package libimage-exiftool-perl
#
#  sips -g all path/file.extension (for images)
#  identify -verbose path/file.extension (for images)
# pdfinfo

set -e

metadata_show() 
{
    localc fpath="$1"
    local fname=$(basename -- "$fpath")
    local fsuffix="${filename##*.}"
    local fsuffixlower=$(echo "$fsuffix" | tr '[:upper:]' '[:lower:]')
    file $fpath

    case "$fsuffixlower" in
        jpg|png)
            identify -verbose "$fpath"
      
        ;;
        pdf)
            pdfinfo "$fpath"
            pdfinfo -meta "$fpath"
        ;;

        *)
            echo $"Unable to detect filesuffix}"
            exit 1
 
    esac

}
