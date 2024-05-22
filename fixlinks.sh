#!/bin/sh


_usage() {
    cat << EOF
USAGE:
    fixlinks.sh FUNCTION PATH
DESCRIPTION:
    Recursively find symbolic links in PATH. Remove broken symlinks, or
    replace symlinks with hard links. A hard link can only be created if the symlink points to a file and not a directory. If its target is not a file, the symlink will be skipped and left in place.
FUNCTIONS:
    harden
        convert unbroken symbolic links to hard links
    clean
        delete broken symbolic links
EXAMPLES:
    fixlinks.sh harden /mnt/hdd0/
    fixlinks.sh clean /mnt/hdd0/
EOF
}


clean() {
    echo Remove broken symbolic links...

    # -P to explicitly never follow symlinks
    # -xtype returns true if symlink points to a file of the type specified
    # if a symlink points to a symlink, that means it's broken
    OUTPUT=$(find -P "$1" -xtype l -ok rm -- {} \; -printf 'DELETED: %p\n')
    if [ -z "$OUTPUT" ]; then
        echo Nothing to remove.
    else
        echo "$OUTPUT"
    fi
}


harden() {
    echo Replace symbolic links with hard links...

    # find symlinks (-type l) but not broken symlinks (-xtype l)
    # -0 interprets null line endings from -print0 and preserves whitespace
    find -P "$1" -type l ! -xtype l -print0 | xargs -0 -- sh -c -- '
        for link; do
            dest="$(readlink -f "$link")"
            if [ -f "$dest" ]; then
                # read from terminal instead of stdin because of pipe
                rm -i -- "$link" </dev/tty
                if [ ! -e "$link" ]; then
                    ln -- "$dest" "$link" &&
                    echo Created hard link at: "$link"
                fi
            fi
        done
    ' sh
    # 'sh' fills param $0 for the sh command, so that it doesn't consume any
    # lines from the find output. Any string will work as a placeholder. 
}


# Call arguments to script if first arg is a function
case $(type -- "$1" 2>/dev/null) in
    *function*)
        if [ ! -d "$2" ]; then
            echo Not a valid directory: "$2"
            exit 1
        fi

        # "$@" calls the script's positional arguments in order
        # $1 is the name of the function to call
        # $2 gets passed as the first arg to the function

        "$@"

        ;;
    *)
        # If not a function, print help
        _usage
        ;;
esac

