#!/usr/bin/env sh

# Download and install latest discord tar.gz file to $destdir/Discord

destdir="$HOME/Apps/"

if [ -z "$destdir" ]; then
    echo ERROR: No destination defined
    exit 1
elif [ -d "$destdir" ]; then
    rm -r "$destdir/Discord" 2>/dev/null &&
    echo "Old version removed: $_"
    wget --content-disposition -q -O - "https://discord.com/api/download?platform=linux&format=tar.gz" | 
    tar xvz -C "$destdir" &&
    echo New version finished installing ||
    echo ERROR: Installation failed &&
    exit 1
else
    echo "Invalid destination: $destdir"
    exit 1
fi

exit 0
