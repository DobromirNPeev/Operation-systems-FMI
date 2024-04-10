#!/bin/bash

if [[ $# -ne 2 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -f "${1}" ]];then
        echo "Not a file"
        exit 2
fi

csv="${1}"
type="${2}"

constellation="$(cat "${csv}" | grep ",${type}," | cut -d ',' -f 4 | sort | uniq -c | xargs -L 1 | sort -k 1 -t ' ' -rn | head -n 1 | cut -d ' ' -f 2)"

grep ",${constellation}," "${csv}" | grep -v ',--$' |sort -k 7 -t ',' -n | head -n 1 | cut -d ',' -f 1
