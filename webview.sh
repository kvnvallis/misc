#!/usr/bin/env bash
#
# View a markdown file in a web browser. Add [TOC] on its own line near the top
# of your markdown file to generate a table of contents. 
#
# Requires python-markdown. Old versions of python-markdown may not support the
# "toc_depth" parameter. In that case, change $mdcmd to one of the other
# available options, or create your own.
#
# Useage:
#
#     $ webview ~/notes.md
#

scriptname="$(basename "$0")"
appname="${scriptname%.*}"
browser=firefox
cssfile=""
datetime="$(date +%Y%m%d%H%M%S)"
tmpdir="/tmp/${appname}/"
tmpfile="${datetime}.html"
outfile="${tmpdir}${tmpfile}"

mdcmd="python -m markdown -x toc -c <(printf \"toc:\n  toc_depth: 2-3\n\")"
#mdcmd="python -m markdown -x toc"
#mdcmd="markdown"

main() {
    # Create html files in /tmp and open in a browser

    mdfile="$1"

    if [ ! -d "$tmpdir" ]; then
        mkdir "$tmpdir"
    fi

    if [ -n "$cssfile" ]; then
        printf "<link rel=\"stylesheet\" href=\"%s\">\n" "$cssfile" > "$outfile"
    fi

    eval "$mdcmd" "$1" >> "$outfile" && "$browser" "$outfile"
}

main "$1" & disown
