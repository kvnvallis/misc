#!/usr/bin/env sh
#
# A generic processing loop for running ffmpeg on multiple files. Outputs to current directory.
#
# Useage:
#     $ ffloop.sh ./*.mkv
#     $ ffloop.sh ./files.txt

extract_subs=true
vid_extension=".mpg"
sub_extension='.srt'
vidout_opts="-target film-dvd"
subout_opts="-c:s text"
opts_in=""  # applied to input; usually not needed

run_ffmpeg() {
    video_in="$1"
    filename_dot_ext=$(basename -- "$video_in")
    filename="${filename_dot_ext%.*}"
    video_out="${filename}${vid_extension}"
    subtitle_out="${filename}${sub_extension}"
    if [ $extract_subs ] ; then
        ffmpeg -nostdin $opts_in -i "${video_in}" ${vidout_opts} "${video_out}" $subout_opts "$subtitle_out"
    else
        ffmpeg -nostdin $opts_in -i "${video_in}" ${vidout_opts} "${video_out}"
    fi
}

# Read each line of a file as input to ffmpeg
if [ $# == 1 ] && [ -f "$1" ] && [ ${1##*.} == 'txt' ]; then
    args_file="$1"
    while read infile; do
        run_ffmpeg "$infile"
    done < "$args_file"
else  # Read input files from the command line
    for infile in "$@"; do
        run_ffmpeg "$infile"
    done
fi
