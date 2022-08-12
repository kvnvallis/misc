# Odds and ends

Experiments, coding challenges, and anything else.

## fixlinks.sh

Small posix script meant to be used with `find -exec` to fix symlinks where target files or folders have moved to a new location. Preserves symlink filenames and parent folders of the symlink targets. 

## autoip.py

Autocompletes ip addresses for the subnet mask `255.255.255.0`, using a recursive function that counts by concatenating numerical strings. 

## mkdvd.sh

Just make an iso of a dvd filesystem and burn it for playback on a home dvd player.

## webview.sh

Look at markdown files rendered in your web browser.

## workon.sh

A shell function for activating python virtual environments. Useful on windows or anywhere you can't install virtualenvwrapper.

## ffloop.sh

Run ffmpeg on multiple files. Encoding options are loaded from a config file. Subtitles and audio can be extracted separately. Two-pass encoding is also supported. 
