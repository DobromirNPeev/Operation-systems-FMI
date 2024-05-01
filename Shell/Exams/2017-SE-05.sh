#!/bin/bash

if [[ "${#}" -ne 2]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -d "${1}" ]];then
        echo "Not a directory"
        exit 2
fi

dir="${1}"
string="${2}"

valid_files="$(find "${dir}" -maxdepth 1 -type f | grep -E "vmlinuz-[0-9]+\.[0-9]+\.[0-9]+-${string}" | sort -k 2 -t '-' -rn | head -n 1)"

echo "$(basename ${valid_files})"
