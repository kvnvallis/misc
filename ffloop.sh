#!/usr/bin/env sh

# A generic processing loop for running ffmpeg on multiple files. Outputs to current directory. If a text file is given as an argument, each line should contain the path to a single file, which will be passed to ffmpeg.

# Useage:
#	  $ ffloop.sh ./*.mkv
#	  $ ffloop.sh ./files.txt

### USER CONFIG ###

DRY_RUN=false  # echo commands but don't run them
TWO_PASS=false
EXTRACT_SUBS=true
EXTRACT_AUDIO=false
VID_EXTENSION=".mkv"
SUB_EXTENSION=".srt"
AUD_EXTENSION=""
VIDOUT_OPTS="-map 0:v:0 -map 0:a:1 -c:a copy -c:v libx264 -s 640x480 -crf 18"
SUBOUT_OPTS="-map 0:s:1 -c:s text"
AUDOUT_OPTS="-c:a libmp3lame -q:a 1"
OPTS_IN=""	# applied to input; usually not needed

### END OF USER CONFIG ###


run_ffmpeg() {
	# Takes one argument, the name of the input file to ffmpeg
	if [ ! -f "$1" ] || [ $# -gt 1 ]; then
		echo Is not a file: "$1"
		return
	fi

	video_in="$1"
	filename_dot_ext=$(basename -- "$video_in")
	filename="${filename_dot_ext%.*}"
	video_out="${filename}${VID_EXTENSION}"
	subtitle_out="${filename}${SUB_EXTENSION}"
	audio_out="${filename}${AUD_EXTENSION}"
	base_cmd="-nostdin $OPTS_IN -i \"$video_in\""

	# Assign ffmpeg arguments to function's positional parameters, so we can build the command line piece by piece. Use of eval is required for $video_in filesname to expand properly.
	eval set -- "$base_cmd"

		if [ "$TWO_PASS" = 'true' ]; then
			pass_count=1
			set -- "$@" $VIDOUT_OPTS -pass $pass_count -an -f null -y /dev/null
			if [ "$DRY_RUN" != 'true' ]; then
				ffmpeg "$@"
			else
				echo ffmpeg "$@"
			fi
			pass_count=$((pass_count+1))
		fi

	# Test if video file exists, because sometimes we want to leave it in place while extracting audio or subtitles, without also re-encoding the video.
	if [ ! -f "$video_out" ]; then
		if [ "$pass_count" -eq 2 ]; then
			eval set -- "$base_cmd"
			set -- "$@" $VIDOUT_OPTS -pass $pass_count "$video_out"
		else
			# same thing as above but without -pass
			set -- "$@" $VIDOUT_OPTS "$video_out"
		fi
	else
		echo "Video file already exists."

	fi

	if [ "$EXTRACT_SUBS" = 'true' ]; then
		set -- "$@" $SUBOUT_OPTS "$subtitle_out"
	fi

	if [ "$EXTRACT_AUDIO" = 'true' ]; then
		set -- "$@" $AUDOUT_OPTS "$audio_out"
	fi

	if [ "$DRY_RUN" != 'true' ]; then
		ffmpeg "$@"
	else
		echo ffmpeg "$@"
	fi
}


# Read each line of a file as input to ffmpeg
if [ $# -eq 1 ] && [ -f "$1" ] && [ "${1##*.}" = 'txt' ]; then
	args_file="$1"
	while read infile; do
		run_ffmpeg "$infile"
	done < "$args_file"
else  # Read input files from the command line
	for infile in "$@"; do
		run_ffmpeg "$infile"
	done
fi
