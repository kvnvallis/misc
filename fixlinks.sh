#!/bin/sh


_usage() {
    cat << EOF
USAGE:
    fixlinks.sh FUNCTION PATH
DESCRIPTION:
    Recursively find symbolic links in PATH. Remove broken symlinks, or
    replace symlinks with hard links.
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

    # -xtype returns true if symlink points to a file of the type specified
    # if a symlink points to a symlink, that means it's broken
    OUTPUT=$(find "$1" -xtype l -ok rm -- {} \; -printf 'DELETED: %p\n')
    if [ -z "$OUTPUT" ]; then
        echo Nothing to remove.
    else
        echo "$OUTPUT"
    fi
}


harden() {
    echo Replace symbolic links with hard links...

    # find symlinks (-type l) but not broken symlinks (-xtype l)
    # -I {} required to prevent spaces being collapsed or trimmed
    find "$1" -type l ! -xtype l -print0 | xargs -0 -I {} sh -c '
        for file in "{}"; do
            #echo $0    # debug param $0
            dest="$(readlink -e "$file")"
            # read from terminal instead of stdin because of pipe
            rm -i -- "$file" < /dev/tty
            if [ ! -e "$file" ]; then
                ln "$dest" "$file" &&
                echo Created hard link at: "$file"
            fi
        done
    ' sh
    # 'sh' fills param $0 for the sh command, so that it doesn't consume any
    # lines from the find output. Any string will work as a placeholder. 
}


# Call arguments to script if first arg is a function
case "$(type -- "$1" 2>/dev/null)" in
    *is\ a\ function*)
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

