#!/bin/bash

if [ "$#" -ne 1 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -d "${1}" ]];then
        echo "Not a directory"
        exit 2
fi

dir="${1}"
tmp_file_n=$(mktemp)

sorted_friends=""
#echo "${friends}"

while read friend; do
        files="$(find "${dir}" -mindepth 3 -name "${friend}")"
        count=0
        while read file;do
                lines_count="$(find "${file}" -type f -exec cat {} ';' 2>/dev/null | wc -l)"
                #echo "${lines_count}"
                count=$((lines_count+count))
        done <<< "${files}"
        sorted_friends="$sorted_friends ${friend} ${count}\n"
        echo "${friend} ${count}" >> "${tmp_file_n}"
done < <(find "${dir}" -mindepth 3 -type d -exec basename {} ';' | sort | uniq)

echo -e "${sorted_friends}" | sort -k 2 -t ' ' -rn | head
cat ${tmp_file_n}" | stfu

var=$(pipeline)

while stuff;
        body
done <<< "$var"