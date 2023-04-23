#!/usr/bin/sh

# Launch master levels of doom pwads with chocolate-doom.

# INSTALLATION:
#     1. Copy master.sh to Master Levels of Doom folder 
#     2. Create symlink to master.sh somewhere in your path
# EXAMPLE:
#     cp master.sh "$HOME/games/Master Levels of Doom/master.sh"
#     ln -s "$HOME/games/Master Levels of Doom/master.sh" ~/bin/master.sh

# USAGE:
#     master.sh FUNCTION [PWAD]
# EXAMPLES:
#     master.sh list
#     master.sh run attack.wad

# __NOTE:__ If your wad files are UPPERCASE, make sure to type them that way, or rename
# them to lowercase with the provided rename function:
#     master.sh rename


# First cd into script directory, which should be "Master Levels of Doom" folder
cd "$(dirname -- "$(readlink -f "$0")")"

# Use full paths, or paths relative to script location
# Defaults assume directory structure of Steam release
pwads_dir='./master/wads/'
doom2_wad='./doom2/DOOM2.WAD'

list() {
    # List wad files in $pwads_dir
    for file in "$pwads_dir"/*.[Ww][Aa][Dd]; do
        echo $(basename "$file")
    done
}

rename() {
    # Rename all your wads in $pwads_dir to lowercase, so they're easier to type
    for file in "$pwads_dir"/*.[Ww][Aa][Dd]; do
        newfile="${file,,}"
        if [ "$file" != "$newfile" ]; then
            mv -- "$file" "$newfile" && \
            echo RENAMED: $(basename "$file") to $(basename "$newfile")
        fi
    done
}

run() {
    chocolate-doom -iwad "$doom2_wad" -file "$pwads_dir"/"$1" -episode 1
}

"$@"
