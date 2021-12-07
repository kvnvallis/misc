#!/usr/bin/env sh
#
# Loop through a list of mpeg files and mux a subtitle stream into each file.
# Subtitles must be in .srt format and have the same filename as the mpeg file,
# in the same directory. Output subtitled mpegs to current directory. To use
# script, copy files to a src folder and create a symlink to dvdsub.sh
# somewhere in your $PATH. The xml file must exist in the same directory as the
# script.
#
# Installation:
#     $ mkdir -p ~/bin/src/dvdsub && cp dvdsub.sh envsub.xml ~/bin/src/dvdsub/
#     $ chmod u+x ~/bin/src/dvdsub/dvdsub.sh
#     $ cd ~/bin && ln -s ./src/dvdsub/dvdsub.sh
#
# Useage:
#     $ dvdsubs.sh ./video/*.mpg

scriptpath="$(realpath "$0")"
scriptdir="${scriptpath%/*}"
xmlfile="${scriptdir}/envsub.xml"

# Subtitle XML file variables
export format="NTSC"
export font="xerox.ttf"  # Place in ~/.spumux directory
# Use video's actual resolution (not always the dvd standard 720x576)
export movie_width="640"  
export movie_height="480"
export force="no"  # "yes" for subtitles that can't be turned off

for infile in "$@"; do
    export srtfile="${infile%.*}.srt"
    vidfile_dot_ext=$(basename -- "$infile")
    vidfilename="${vidfile_dot_ext%.*}"
    vidfile_ext="${vidfile_dot_ext##*.}"
    outfile="./${vidfilename}_subs.${vidfile_ext}"
    if [ -f "$infile" ] && [ -f "$srtfile" ]; then
        xml="$(envsubst < "$xmlfile")"
        spumux -s0 <(echo "$xml") < "$infile" > "$outfile"
    else
        echo Missing files for "${vidfilename}"
    fi
done
