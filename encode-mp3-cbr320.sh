#!/bin/sh


encode_mp3_vlc()
{
    local infile="$1"
    local outfile="$2"
    #vlc -I dummy 
    #--dummy-quiet 
    vlc --intf=dummy \
        $infile \
        ":sout=#transcode{acodec=mpga,ab=320}:std{dst=$outfile,access=file}" \
        vlc://quit
}

encode_mp3_ffmpeg()
{
    local infile="$1"
    local outfile="$2"
    ffmpeg -i $infile -codec:a libmp3lame -qscale:a 320k $outfile
}

encode_mp3()
{
    local infile="$1"
    local bname=$(basename $infile)
    local outfile="${bname%.*}.mp3"

    if [ ! -f "$infile" ]; then
        echo "E: Invalid input file $infile"
        exit 1
    fi

    if [ -f "$outfile" ]; then
        echo "E: File $outfile already exists"
        exit 1
    fi
}
