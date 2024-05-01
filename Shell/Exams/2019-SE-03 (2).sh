#!/bin/bash

if [[ "${#}" -ne 1 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -d "${1}" ]];then
        echo "Not a directory"
        exit 2
fi


dir="${1}"
last_exec="$(stat -c "%X" "${0}")"
valid_archives="$(mktemp)"
find "${dir}" -type f -printf "%p %M@\n" > "${valid_archives}"

dir="${1}"

while read archive;do
        name="$(basename "${archive}" | grep -E -o "^[^_]*")"
        timestamp="$(basename "${archive}" | sed -E 's/^[^_]+_report-(.*)\.tgz$/\1/')"
        echo "${name} ${timestamp}"
        while read file;do
                if [[ ! -d "extracted" ]];then
                        mkdir -p "${dir}/extracted"
                fi
                if [[ ! -f "${file}" ]];then
                        tar -xf "${archive}" "${file}"
                        mv "${file}" "${dir}/extracted/${name}_${timestamp}.txt"
                        rm -r "$(echo ${file} | grep -o -E "^[^/]*")"
                        break
                fi
        done < <(tar -tf "${archive}" | grep -F "meow.txt")
done < <(cat "${valid_archives}" |      awk -v var="${last_exec}" '$2>=var { print $1}' | grep -E "^[^_]*_report-[0-9]*\.tgz")

rm "${valid_archives}"
