#!/bin/bash

if [ $# -ne 1 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if ! [ -d  "${1}" ];then
        echo "Not a directory"
        exit 2
fi

while read -r file;do
        if ! [ -e "${file}" ];then
                echo "${file}"
        fi
done < <(find "${1}" -type l 2>/dev/null)
