#!/usr/bin/env sh

# Fix symlinks where the target files have been moved to a new location.

# Run this script on multiple files using `find -exec`:
# find /home/kodi/library -lname '/mnt/files/btdownloads/*' -exec ./fixlink.sh {} \;

# Or test it on just one file:
# ./fixlink.sh /home/kodi/library/movie.mkv

# The script works by reading the symlink and modifying the path to its target
# file. OLDPATH is replaced with NEWPATH in TARGET_FILE, and the symlink is
# overwritten with a new link that points to the NEW_TARGET_FILE. 

## Path to symlink provided as the only argument to the script
SYMLINK="$1"

## Full path to the new folder where target files reside
NEWPATH="/mnt/storage/"

## Full path to the folder where target files used to live 
OLDPATH="/mnt/files/"

## Full path to where the symlink is currently pointing
TARGET_FILE="$(readlink "$SYMLINK")"

## Path to target file with OLDPATH prefix removed
TARGET_BASEDIR="${TARGET_FILE#${OLDPATH}}"

## Path to target file prefixed with NEWPATH
NEW_TARGET_FILE="${NEWPATH}${TARGET_BASEDIR}"

## Uncomment `ln -sf` to create symlinks
echo Link to file "$NEW_TARGET_FILE" and put link at "$SYMLINK"
#ln -sf "$NEW_TARGET_FILE" "$SYMLINK"

