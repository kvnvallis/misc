#!/usr/bin/env sh
#
# A cheap version of virtualenvwrapper's workon command
# Source this file or copy it into your .bashrc

workon() {
    if [ $# -eq 0 ]; then
        echo No arguments given to $(basename "$0"); return
    fi

    project="$1"
    workon_home="$HOME/Pyvenvs/"

    if [ -d "${workon_home}/${project}" ]; then
        source "${workon_home}/${project}/Scripts/activate"
    else
        echo No project found in $workon_home by name $project
    fi
}
