#!/usr/bin/env sh
#
# A generic processing loop for running ffmpeg on multiple files

extension=".mp4"  # file type for output files
opts="-map 0:v -map 0:a -c copy -map_chapters -1"  # options supplied to ffmpeg

for infile in "$@"; do
    filename="${infile%.*}"
    outfile="${filename}${extension}"
    ffmpeg -i "${infile}" ${opts} "${outfile}"
done
