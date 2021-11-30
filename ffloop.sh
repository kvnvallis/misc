#!/usr/bin/env sh
#
# A generic processing loop for running ffmpeg on multiple files. Outputs to
# current directory.
#
# Useage:
#     ffloop.sh ./*.mkv

extension=".mp4"  # file type for output files
opts_out="-map 0:v -map 0:a -c copy -map_chapters -1" # options applied to ffmpeg output
opts_in=""

run_ffmpeg() {
    video_in="$1"
    filename_dot_ext=$(basename -- "$video_in")
    filename="${filename_dot_ext%.*}"
    video_out="${filename}${extension}"
    ffmpeg -nostdin $opts_in -i "${video_in}" ${opts_out} "${video_out}"
}

## Read each line of a file as input to ffmpeg
if [ $# == 1 ] && [ -f "$1" ] && [ ${1##*.} == 'txt' ]; then
    args_file="$1"
    while read infile; do
        run_ffmpeg "$infile"
    done < "$args_file"
## Read input files from the command line
else
    for infile in "$@"; do
        run_ffmpeg "$infile"
    done
fi
