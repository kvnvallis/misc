#!/usr/bin/env sh

# Combine subtitle files with a video file of the same name.
#
# USEAGE:
#	submux.sh ./*.mkv

# Change to match your subtitle files
SUBTITLE_EXTENSION=".srt"

for infile in "$@"; do
	filename=$(basename "$infile")
	extension="${filename##*.}"
	filename_noext="${filename%.*}"
	subfile="${filename_noext}.srt"
	outdir=$(dirname "${infile}")/submux
	if [ ! -e "$outdir" ]; then
		mkdir "$outdir"
		echo Created output directory at "$outdir"
	fi
	if [ -f "$subfile" ] && [ -d "$outdir" ]; then
		ffmpeg -nostdin -i "$infile" -i "$subfile" -c copy "${outdir}/${filename}"
	else
		echo Missing subtitle file or output directory
	fi
done
