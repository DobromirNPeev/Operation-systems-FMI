#!/bin/bash

#while read -r file;do
#       if [ -d "${file}" ];then
#               echo "$(pwd) has a directory"
#               exit 1
#       fi
#done < <(find . -mindepth 1 -maxdepth 1)

if [[ $# -ne 2 ]];then
        echo "Invalid number of arguments"
        exit 2
fi

if [[ ! "${1}" =~ ^[0-9]+ ]] || [[ ! "${2}" =~ ^[0-9]+ ]];then
        echo "Not a number"
        exit 3
fi

first="${1}"
second="${2}"

if [[ ! -e "$(pwd)/a" ]];then
        mkdir "$(pwd)/a"
fi

if [[ ! -e "$(pwd)/b" ]];then
        mkdir "$(pwd)/b"
fi

if [[ ! -e "$(pwd)/c" ]];then
        mkdir "$(pwd)/c"
fi

while read -r file;do
        lines_count=$(cat "${file}" | wc -l)
        if [[ $lines_count -lt $first ]];then
                mv "${file}" "$(pwd)/a"
        elif [[ $lines_count -ge $first && $lines_count -le $second ]];then
                mv "${file}" "$(pwd)/b"
        else
                mv "${file}" "$(pwd)/c"
        fi
done < <(find . -mindepth 1 -maxdepth 1 -type f)
