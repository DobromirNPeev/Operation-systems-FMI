#!/bin/bash

if [ $# -ne 1 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if ! [ -d "${1}" ];then
        echo "Not a directory"
        exit 2
fi

dir="${1}"

find "${dir}" -maxdepth 1 | while read -r line;do
        if [[ "$(stat -c "%F" "${line}")" == "regular file" ]];then
                echo "${line} ($(stat -c "%s" "${line}") bytes)"
        else
                echo "${line} ($(find "${line}" -maxdepth 1 | wc -l) entries)"
        fi
done
