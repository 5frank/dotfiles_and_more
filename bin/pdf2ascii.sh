#!/bin/sh

assert_command()
{
    local cmd="$1"
    local cmdinfo="$2"
    command -v $cmd >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo >&2 "E: Command '$cmd' not installed. \n $cmdinfo \n"
        exit 1 
    fi

}

pdf_to_ascii()
{
    assert_command pdftotext "avalable in debian package 'poppler-utils'"
    assert_command uni2ascii "avalable in debian package 'uni2ascii'"

    echo "adfs"
    local tmpfile=$(mktemp -t pdftoascii_dump.tmp.XXXXXXXXXX)

    # TODO add page numbers? 
    # `$ pdftotext -f 10 -l 12 -layout foo.pdf out.txt`
    pdftotext -layout "$1" $tmpfile

    #  replaces other chars with \u00E9 qith format `-a U`.
    uni2ascii -ex -a U $tmpfile 

    rm -f $tmpfile 
}


pdf_to_ascii "$@"
