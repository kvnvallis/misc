#!/usr/bin/env sh

# A generic processing loop for running ffmpeg on multiple files. Outputs to current directory. If a text file is given as an argument, each line should contain the path to a single file, which will be passed to ffmpeg.

# Useage:
#     $ ffloop.sh ./*.mkv
#     $ ffloop.sh ./files.txt


### USER CONFIG ###

TWO_PASS=false
EXTRACT_SUBS=true
VID_EXTENSION=".mkv"
SUB_EXTENSION=".srt"
VIDOUT_OPTS="-map 0:v:0 -map 0:a:0 -c:a copy -c:v libx264 -s 640x480 -aspect 4:3 -crf 18"
SUBOUT_OPTS="-map 0:s:0 -c:s text"
OPTS_IN=""  # applied to input; usually not needed

### END OF USER CONFIG ###


run_ffmpeg() {
    video_in="$1"
    base_cmd="ffmpeg -nostdin $OPTS_IN -i"
    filename_dot_ext=$(basename -- "$video_in")
    filename="${filename_dot_ext%.*}"
    video_out="${filename}${VID_EXTENSION}"
    subtitle_out="${filename}${SUB_EXTENSION}"

    if [ -f "./${video_out}" ] && [ $EXTRACT_SUBS = true ]; then
        echo Encoding subtitles only
        $base_cmd "$video_in" $SUBOUT_OPTS "$subtitle_out"

    elif [ $EXTRACT_SUBS = true ]; then
        echo Encoding video and subtitles
        if [ $TWO_PASS = true ]; then
            $base_cmd "$video_in" -pass 1 $VIDOUT_OPTS -an -f null -y /dev/null && \
            $base_cmd "$video_in" -pass 2 $VIDOUT_OPTS "$video_out" $SUBOUT_OPTS "$subtitle_out"
        else
            $base_cmd "$video_in" $VIDOUT_OPTS "$video_out" $SUBOUT_OPTS "$subtitle_out"
        fi

    else
        echo Encoding video
        if [ $TWO_PASS = true ]; then
            $base_cmd "$video_in" -pass 1 $VIDOUT_OPTS -an -f null -y /dev/null && \
            $base_cmd "$video_in" -pass 2 $VIDOUT_OPTS "$video_out"
        else
            $base_cmd "$video_in" $VIDOUT_OPTS "$video_out"
        fi
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
