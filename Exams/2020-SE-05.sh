#!/bin/bash

if [[ "${#}" -ne 3 ]];then
        echo "Invalid number of arguments"
        exit 3
fi

if [[ ! -d "${3}" ]];then
        echo "Not a directory"
        exit 2
fi

if [[ ! -f "${1}" ]];then
        echo "Not a file"
        exit 1
fi

file1="${1}"
file2="${2}"
dir="${3}"

while read file;do
        valid="$(cat "${file}" | grep -n -v -E '^#|^{ .* };|^$')"
        if [[ -n "${valid}" ]];then
                echo "Error in $(basename ${file}):"
                echo "${valid}" | while read line;do
                        echo "Line ${line}"
                done
        else
                cat "${file}" >> "${file2}"
                name="$(basename "${file}" .cfg)"
                if ! grep -q "${name}" "${file1}";then
                        passwd="$(pwgen 16 1)"
                        hash="$(echo "${passwd}" | md5sum | cut -d ' ' -f 1)"
                        echo "${name}:${hash}" >> "${file1}"
                        echo "Username:${name} Password:${passwd}"
                fi
        fi
done < <(find "${dir}" -type f -name '*.cfg')
