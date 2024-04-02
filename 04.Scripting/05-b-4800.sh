#!/bin/bash

if [ $# -ne 2 ];then
        echo 'Invalid number of arguments'
        exit 1
fi

if ! [ -f "${1}" ];then
        echo "Not a file"
        exit 1
fi

if ! [ -d "${2}" ];then
        echo "Not a directory"
        exit 1
fi

original_content="${1}"
dir="${2}"
files="$(find "${dir}" -type f 2>/dev/null)"

find ${dir} -type f 2>/dev/null | while read -r file;do
        diff -q "${file}" "${original_content}" > /dev/null
        if [ $? -eq 0 ];then
                echo "${file}"
        fi
done
