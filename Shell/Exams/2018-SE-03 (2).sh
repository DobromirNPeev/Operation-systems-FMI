#!/bin/bash

firstdir="${1}"
seconddir="${2}"


temp_file=$(mktemp)
echo "$(cat "${firstdir}" | cut --complement -f 1 -d ',' | sort | uniq)" > $temp_file
if [[ ! -f "${seconddir}" ]];then
        touch "${seconddir}"
fi

while read line;do
        cat "${firstdir}" | grep -E "^[0-9]+,${line}$" | sort -n -k 1 -t ',' | head -n 1 >> "${seconddir}"
done < "${temp_file}"

rm "${temp_file}"
