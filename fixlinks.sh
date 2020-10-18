#!/usr/bin/env sh

# Fix symlinks where the target files have been moved to a new location.

# Run this script using `find -exec`, e.g.
# find /media/usb/library -lname '/home/kodi/btdownloads/*' -exec ./fixlinks.sh {} \;

# The script works by reading the symlink and modifying the path to its target
# file. OLDPATH is replaced with NEWPATH in TARGET_FILE, and the symlink is
# overwritten with a new link that points to the NEW_TARGET_FILE. 

SYMLINK="$1"
NEWPATH="/media/usb/"
OLDPATH="/home/kodi/"
TARGET_FILE="$(readlink "$SYMLINK")"
TARGET_BASEDIR="${TARGET_FILE#${OLDPATH}}"
NEW_TARGET_FILE="${NEWPATH}${TARGET_BASEDIR}"

# Uncomment `ln -sf` to create symlinks

echo Link to file "$NEW_TARGET_FILE" and put link at "$SYMLINK"
#ln -sf "$NEW_TARGET_FILE" "$SYMLINK"

