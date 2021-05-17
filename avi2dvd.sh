#!/usr/bin/env bash

# Convert a 23fps standard definition video file to ntsc dvd format, i.e. mpeg2
# vob with pulldown flags for aspect ratio and framerate. 

INFILE="$1"
OUTFILE="$2"

# -vf scale was derived from the expanded NTSC width (a constant 854) divided
# by the aspect ratio of the input file. So if running ffprobe on the input
# file shows `720x304 [SAR 1:1 DAR 45:19]`, 45/19=2.37 and 854/2.37=360, so
# scale=720:360

# Audio can be copied with `-oac copy` so long as it is ac3. The audio options
# for -lavcopts probably don't apply in this case.

# To avoid duplicating frames, the ntsc pulldown flag is added with `-mpegopts
# telecine -ofps 24000/1001`. This allows the dvd player to convert 23fps to
# 29fps the way it does with commercial dvds.

# CMDOPTS is an array where each item is separated by a space or a newline. You
# can experiment with command line options by commenting out lines in the
# array.

CMDOPTS=(
    # Comments inside arrays really do work
    -vf scale=720:360,expand=720:480
    -oac copy -ovc lavc
    -lavcopts vcodec=mpeg2video:aspect=16/9:keyint=15:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=6000:vstrict=0:acodec=ac3:abitrate=192
    -of mpeg -mpegopts format=dvd:tsaf:telecine -ofps 24000/1001
)

mencoder -o "$OUTFILE" "${CMDOPTS[@]}" "$INFILE"


