#!/usr/bin/env sh

# Download and install latest discord tar.gz file to $destdir/Discord

destdir="$HOME/Apps/"

if [ -d "$destdir" ]; then
    rm -r "$destdir/Discord" 2>/dev/null &&
    echo "Old version removed: $_"
    wget --content-disposition -q -O - "https://discord.com/api/download?platform=linux&format=tar.gz" | 
    tar xvz -C "$destdir" &&
    echo New version finished installing ||
    echo ERROR: Installation failed
else
    echo "Invalid destination: $destdir"
fi
