#!/bin/bash

if [[ ! -f "${1}" ]];then
        echo "Not a file"
        exit 1
fi

if [[ ! -d "${2}" ]];then
        echo "Not a dir"
        exit 2
fi

bad_words="${1}"
dir="${2}"

while read file;do
        while read word;do
                n="$(echo "${word}"     | wc -c)"
                str=""
                while [[ "${n}" -gt "0" ]];do
                        str+="*"
                        n=$((n-1))
                done
                sed -i -E "s/\<${word}\>/${str}/g" "${file}"
        done < <(cat "${bad_words}")
done < <(find "${dir}" -type f -name "*.txt")
