#!/usr/bin/env sh

# Written for and tested on a thinkpad e455 running arch linux with lm_sensors and thinkpad_acpi

# This script looks for the directory containing the sensor name and creates a
# symlink (in $HOME) to the temperature file from that same directory

# We have to do this because the order of the hwmon files changes at boot. Run
# the script at startup so that a new symlink is created each time you restart
# your computer.

# The resulting symlink can be used as the path for the temperature sensor in /etc/i3status.conf


sensor='k10temp'

for path in /sys/class/hwmon/hwmon*; do
    read line < "${path}/name"
    if [ "$line" = "$sensor" ]; then
        ln -sf "${path}/temp1_input" "${HOME}/.${line}"
        break
    fi
done
