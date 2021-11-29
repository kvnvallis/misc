#!/usr/bin/env sh
#
# A generic processing loop for running ffmpeg on multiple files. Outputs to
# current directory.
#
# Useage:
#     ffloop.sh ./*.mkv

extension=".mp4"  # file type for output files
opts_out="-map 0:v -map 0:a -c copy -map_chapters -1"
opts_in=""

for infile in "$@"; do
    extfilename=$(basename -- "$infile")
    filename="${infile%.*}"
    outfile="${filename}${extension}"
    ffmpeg ${opts_in} -i "${infile}" ${opts_out} "${outfile}"
done
