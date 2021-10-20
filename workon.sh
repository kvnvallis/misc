#!/usr/bin/env sh
#
# A cheap version of virtualenvwrapper's workon command

if [ $# -eq 0 ]; then
    echo No arguments given to $(basename "$0"); exit 1
fi

project="$1"
workon_home="$HOME/Pyvenvs/"

if [ -d "${workon_home}/${project}" ]; then
    source "${workon_home}/${project}/Scripts/activate"
else
    echo No project found in $workon_home by name $project
fi

