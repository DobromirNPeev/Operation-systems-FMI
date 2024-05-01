#!/bin/bash

if [[ "$#" -ne 2 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -f "${1}" || ! -f "${2}" ]];then
        echo "Not a file"
        exit 2
fi

file1="${1}"
file2="${2}"

count_file1="$(grep -F "${file1}" "${file1}" | wc -l)"
count_file2="$(grep -F "${file2}" "${file2}" | wc -l)"

echo "${count_file1} ${count_file2}"

if [[ "${count_file1}" -eq "${count_file2}" ]];then
        echo "No winner"
        exit 3
fi

if [[ "${count_file1}" -gt "${count_file2}" ]];then
        winner="${file1}"
else
        winner="${file2}"
fi

cat "${winner}" | cut -d ' ' -f 4- | sort > "${winner}.songs"
