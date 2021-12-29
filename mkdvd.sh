#!/usr/bin/env bash

# Create an iso and burn a disc for playback on a conventional dvd player
# "$1" -- A folder containing dvd video files
MOVIE=$(basename "$1")
DISC_NAME=$(echo -n "$MOVIE" | tr [:lower:] [:upper:] | tr "\-." " " | tr -d [:punct:] | tr " " "_")
OUTFILE="${MOVIE}.dvd5.iso"
mkisofs -dvd-video -udf -V "$DISC_NAME" -o "./$OUTFILE" "$1" && \
while true; do
    read -p "Burn a DVD? [y/N] " yn
    case $yn in
        [Yy] ) wodim speed=4 dev=/dev/cdrom -v -data "./$OUTFILE"; break;;
        [Nn] | '' ) printf "Burn a disc later with:\n\t wodim -v speed=4 $OUTFILE\n"; exit;; 
    esac
done
