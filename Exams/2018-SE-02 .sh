#!/bin/bash

if [[ "$#" -ne 2 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -f "${1}" ]];then
        echo "Not a file"
        exit 2
fi

if [[ ! -d "${2}" ]];then
        echo "Not a dir"
        exit 3
fi

file="${1}"
dir="${2}"

valid_lines="$(grep -E "^([a-zA-Z-]+) *([a-zA-Z-]+)( \(.+\))?:.*$" "${file}")"

if [[ ! -f "${dir}/dict.txt" ]];then
        touch "${dir}/dict.txt"
fi

dict="${dir}/dict.txt"
count=1

while read person;do
        echo "${person};${count}" >> "${dict}"
        if [[ ! -f "${count}" ]];then
                touch "${dir}/${count}.txt"
        fi
        while read line;do
                echo "${line}" >> "${dir}/${count}.txt"
        done < <(echo "${valid_lines}" | grep -F "${person}" | cut -d ':' -f 2)
        count=$((count+1))
done < <(echo "${valid_lines}" |grep -o -E '^([a-zA-Z-]+ *[a-zA-Z-]+)' | sort |uniq)
