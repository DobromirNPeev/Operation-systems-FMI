#!/bin/bash

if [[ "${#}" -ne 3 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -d "${1}" || ! -d "${2}" ]];then
        echo "Not directories"
        exit 2
fi

if [[ ! "$(whoami)" != "root" ]];then
        echo "User is not root"
        exit 3
fi

src="${1}"
dst="${2}"
str="${3}"

while read file;do
        if basename "${file}" | grep -qF "${str}";then
                if [[ "${file}" == "${src}/$(basename ${file})" ]];then
                        mv "${file}" "${dst}"
                        continue
                fi
                file_copy="$(echo "${file}" | sed -E 's#^[^/]*/##')"
                dirs="$(echo "${file_copy}" | sed -E 's/\/[^/]*$//')"
                mkdir -p "${dst}/${dirs}" 2>/dev/null
                mv "${file}" "${dst}/${dirs}"
        fi
done < <(find "${src}" -type f)
