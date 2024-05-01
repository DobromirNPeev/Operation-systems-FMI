#!/bin/bash

if [[ $# -ne 1]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [ ! -d "${1}" ];then
        echo "Not a directory"
        exit 2
fi

dir="${1}"
files="$(find "${dir}" -type f | wc -l)"
files=$((files/2))
words="$(find "${dir}" -type f -exec cat {} ';'  |sed -E  "s/([a-z]+)/\1\n/g" | tr -d " \t[:punct:]" | grep -E "^[a-z]+$"  | sort | uniq)"
stopwords=""
#echo "${words}"

while read  word;do
        count=0
        while read file;do
                if grep -E -q "\<${word}\>" "${file}";then
                        count=$((count+1))
                fi
        done < <(find "${dir}" -type f)
        echo "${word} ${count}"
        if [[ "${count}" -ge 3 && "${count}" -ge "${files}" ]];then
                stopwords+="${word} ${count}\n"

        fi
done <<< "${words}"

echo -e "${stopwords}" | sort -k 2 -t ' ' -rn | head
#echo "$(find "${dir}" -type f -exec cat {} ';' | grep -E '\<i\>')"
