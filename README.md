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

Run ffmpeg on multiple files, output new files to current directory. 

- Encoding options are loaded from a config file.
- Subtitles and audio can be extracted separately.
- Two-pass encoding is also supported. 
- Dry-run option prints out the ffmpeg command instead of running it.

Install:

1. Clone the repository and copy the `ffloop` folder to a new location like `~/bin/src/ffloop/`
2. Make sure `~/bin` is in your PATH.
3. Create a symlink one level up: `ln -s ~/bin/src/ffloop/ffloop.sh ~/bin/ffloop` 
4. If using windows open cmd.exe as admin and create a symlink with `mklink` instead.
5. Type `ffloop` from any directory (use git bash or cygwin in windows).

