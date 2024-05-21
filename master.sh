#!/usr/bin/sh

# Launch master levels of doom wads with chocolate-doom.

# INSTALLATION:
#     1. Copy master.sh to Master Levels of Doom folder 
#     2. Create symlink to master.sh somewhere in your path
# EXAMPLE:
#     cp master.sh "$HOME/games/Master Levels of Doom/master.sh"
#     ln -s "$HOME/games/Master Levels of Doom/master.sh" ~/bin/master.sh


_usage() {
    cat << EOF
USAGE:
    master.sh FUNCTION [WAD]
EXAMPLES:
    master.sh list
    master.sh run attack.wad
EOF
}


# First cd into script directory, which should be "Master Levels of Doom" folder
cd "$(dirname -- "$(readlink -f "$0")")"


# Use full paths, or paths relative to script location
# Defaults assume directory structure of Steam release
pwads_dir='./master/wads/'
doom2_wad='./doom2/DOOM2.WAD'


_map() {
    case "${1,,}" in
        virgil.wad)
            level=3
            ;;
        minos.wad)
            level=5
            ;;
        bloodsea.wad)
            level=7
            ;;
        mephisto.wad)
            level=7
            ;;
        nessus.wad)
            level=7
            ;;
        geryon.wad)
            level=8
            ;;
        vesperas.wad)
            level=9
            ;;
        blacktwr.wad)
            level=25
            ;;
        teeth.wad)
            level=31
            ;;
        *)
            level=1
            ;;
    esac
}


list() {
    # List wad files in $pwads_dir
    for file in "$pwads_dir"/*.[Ww][Aa][Dd]; do
        echo $(basename "$file")
    done
}


run() {
    _map "$1" && \
    chocolate-doom -iwad "$doom2_wad" -file "$pwads_dir"/"$1" -warp "$level"
}


# Call arguments to script if first arg is a function
case "$(type -t -- "$1") in
    function)
        "$@"
        ;;
    *)
        _usage
        ;;
esac
