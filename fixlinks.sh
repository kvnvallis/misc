#!/bin/sh


SCRIPTNAME=$(basename "$0")

#########
NEWLINE='
'
#########


usage() {
    cat << EOF
USAGE:
    fixlinks.sh FUNCTION PATH
DESCRIPTION:
    Recursively find all symbolic links in PATH. Functions allow you to remove
    broken symlinks, or replace symlinks with hard links. Because of how the
    find command works, PATH can be a folder or a file. But it can not be a
    glob pattern like *.mp4, because the script only takes one path as an
    argument. Only the functions listed below are meant to be run at the
    command line.
FUNCTIONS:
    harden
        Replace unbroken symbolic links with hard links. If a symlink points to a
        directory, the symlink will be replaced with a directory containing
        hard links to all files within the target directory. Sub-directories
        will also be created and their contents linked.
    clean
        delete broken symbolic links
EXAMPLES:
    fixlinks.sh harden /mnt/hdd0/
    fixlinks.sh clean /mnt/hdd0/
EOF
}


# ADVANCED USAGE:
#     "Private" functions are meant to be called within the script, not on the
#     command line. But you can call them on the command line if you want to
#     run them independently. For example, to populate an existing directory
#     with hard links to files in a target directory (instead of first
#     replacing a symlink to a directory) you could manually run the
#     walk_and_link function and pass it 2 command line arguments. Or run
#     link_children if you want to populate a directory without descending into
#     subdirectories. This is also a good way to test the script without
#     operating on any files. Modify the script by adding echo in front of
#     link_children's ln command and it will perform a dry-run.


delete_symlink() {
    # TODO: Write an rm wrapper or auto-populate rm -i input with y so you can
    # just hit enter to delete a file
    link="$1"
    if [ -L "$link" ]; then
        rm -i -- "$link" </dev/tty
        if [ ! -L "$link" ]; then echo DELETED: "$link"; fi
    else
        echo Cannot delete "$link"
        return 1
    fi
}


link_children() {
    # Create hard links for all files inside the target directory at the given
    # location, while ignoring any sub-directories
    target="$1"
    folder="$2"

    if [ -d "$target" ] && [ -d "$folder" ]; then
        find -P "$target" -maxdepth 1 -type f \! -path "*$NEWLINE*" | while IFS= read -r file; do
            ln -- "$file" "$folder"
        done
    else
        return 1
    fi
}


walk_and_link() {
    # Descend into every subdirectory in the target and create hard links to
    # every file along the way, inside a new directory that matches their targets'.
    target="$1"  # target is a directory with files to link to
    folder="$2"  # folder is where links are created

    if [ -d "$target" ] && [ -d "$folder" ]; then
        echo Creating links in "$folder"
        link_children "$target" "$folder"
        # while there are more directories, keep on walking
        find -P "$target" -maxdepth 1 -mindepth 1 -type d \! -path "*$NEWLINE*" | while IFS= read -r subdir; do
            # test on $subdir ignores any blank lines in the find output
            if [ "$subdir" ]; then
                next_folder="$folder/$(basename "$subdir")"
                echo Creating directory "$next_folder"
                mkdir -- "$next_folder"
                walk_and_link "$subdir" "$next_folder"
            fi
        done
    else
        return 1
    fi
}


replace_symlink_to_file() {
    # Replace symbolic link to file with a hard link
    link="$1"
    target=$(realpath -m -- "$link")
    delete_symlink "$link"
    if [ ! -L "$link" ]; then
        # test -f so ln never creates a hard link to a symlink
        [ -f "$target" ] && ln -- "$target" "$link"
    fi
}


replace_symlink_to_dir() {
    link="$1"
    echo "$link"
    target=$(realpath -m -- "$link")
    if [ -L "$link" ]; then
        delete_symlink "$link"
        if [ ! -L "$link" ]; then
            folder="$link"
            mkdir -- "$folder" &&
            walk_and_link "$target" "$folder"
        fi
    fi
}


harden() {
    path="$1"
    echo Replace symbolic links with hard links...
    # find symlinks but not broken symlinks
    find -P "$path" -type l \! -xtype l \! -path "*$NEWLINE*" | while IFS= read -r link; do
        target=$(realpath -m -- "$link")

        if [ -f "$target" ]; then
            # make sure the script doesn't try to replace itself
            if [ $(basename "$target") != "$SCRIPTNAME" ]; then
                echo Target is a file
                replace_symlink_to_file "$link"
            fi
        elif [ -d "$target" ]; then
            echo Target is a directory
            replace_symlink_to_dir "$link"
        fi

    done
}


clean() {
    path="$1"
    echo Remove broken symbolic links...
    # find broken symlinks
    # filter out filenames containing newlines
    find -P "$path" -xtype l \! -path "*$NEWLINE*" | while IFS= read -r link; do
        delete_symlink "$link"
    done
}


case $(type -- "$1" 2>/dev/null) in
    *function*)
        # No function takes more than 2 args
        # -le 3 because 1st arg is function
        if [ $# -le 3 ]; then
            "$@"
        else
            echo Too many arguments
            exit 1
        fi
        ;;
    *)
        usage
        ;;
esac

