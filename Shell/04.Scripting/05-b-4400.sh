#!/bin/bash

if [ $# -gt 2 ] || [ $# -eq 0 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if [ ! -d "${1}" ];then
        echo "Not a directory"
        exit 2
fi

if [ $# -eq 2 ] && [ ! -d "${2}" ];then
        echo "Not a destination directory"
        exit 3
fi

if [ $# -ne 2 ];then
        dest="$(date)"
        mkdir "${dest}"
else
        dest="${2}"
fi

source="${1}"

while read -r line;do
        cp "${line}" "${dest}"
done < <(find "${source}" -maxdepth 1 -type f -mmin -45 2>/dev/null)
