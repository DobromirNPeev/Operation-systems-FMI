#!/bin/bash

if [[ "${#}" -ne 3 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -f "${1}" || ! -f "${2}" ]];then
        echo "Not a file"
        exit 2
fi

file1="${1}"
file2="${2}"
blackhole="${3}"

file1_value="$(grep "${blackhole}" "${file1}" | cut -d ':' -f 2 | xargs -L 1 | cut -d ' ' -f 1)"
file2_value="$(grep "${blackhole}" "${file2}" | cut -d ':' -f 2 | xargs -L 1 | cut -d ' ' -f 1)"


if [[ -z "${file1_value}" || -z "${file2_value}" ]];then
        echo "No such blackhole"
        exit 3
fi

if [[ "${file1_value}" -lt "${file2_value}" ]];then
        echo "${file1}"
elif [[ "${file1_value}" -gt "${file2_value}" ]];then
        echo "${file2}"
else
        echo "${file1} ${file2}"
fi
