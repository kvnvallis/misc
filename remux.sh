#!/usr/bin/env sh
#
# Mux subtitles or audio into a video file and output to a folder in the same directory.
#
# USEAGE:
#	remux.sh ./*.mkv

SUBTITLE_EXT=".srt"
AUDIO_EXT=".mp3"

for infile in "$@"; do
	filename=$(basename "$infile")
	extension="${filename##*.}"
	filename_noext="${filename%.*}"
	subfile="${filename_noext}${SUBTITLE_EXT}"
	audfile="${filename_noext}${AUDIO_EXT}"
	outdir=$(dirname "${infile}")/remux
	if [ ! -e "$outdir" ]; then
		mkdir "$outdir"
		echo Created output directory at "$outdir"
	fi
	if [ -f "$subfile" ] && [ -f "$audfile" ] && [ -d "$outdir" ]; then
		ffmpeg -nostdin -i "$infile" -i "$subfile" -i "$audfile" -c copy "${outdir}/${filename}"
	elif [ -f "$subfile" ] && [ -d "$outdir" ]; then
		ffmpeg -nostdin -i "$infile" -i "$subfile" -c copy "${outdir}/${filename}"
	elif [ -f "$audfile" ] && [ -d "$outdir" ]; then
		ffmpeg -nostdin -i "$infile" -i "$audfile" -c copy "${outdir}/${filename}"
	else
		echo Missing subtitle file, audio file, or output directory
	fi
done
