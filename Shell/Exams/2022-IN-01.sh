#!/bin/bash

if [[ "${#}" -ne 2 ]];then
        echo "invalid number of args"
        exit 1
fi

if [[ ! -d "${1}" ]];then
        echo "not a dir"
        exit 2
fi

if [[ -d "${2}" ]];then
        if [[ -n $(find "${2}" -mindepth 1 -maxdepth 1 -type f) ]];then
                echo "should be empty"
                exit 3
        fi
else
        echo "not a dir"
        exit 2
fi

dir1="${1}"
dir2="${2}"

hidden=$(mktemp)

while read file;do
        bs_name="$(basename "${file}")"
        if echo "${bs_name}" | grep -q -E "^\..*\.swp";then
                echo "${file}" >> "${hidden}"
        fi
done < <(find "${dir1}" -type f)

while read file;do
        bs_name="$(basename "${file}")"
                while read hidden_file;do
                        path_h="$(dirname "${hidden_file}")"
                        path_f="$(dirname "${file}")"
                        if [[ "${path_f}" != "${path_h}" ]];then
                                continue
                        fi
                        bs_h_name="$(basename "${hidden_file}")"
                        og_name="$(echo "${bs_h_name}" | cut -d '.' -f 2)"
                        if [[ "${bs_name}" == "${og_name}" ]];then
                                fat="$(echo "${path_f}" | cut -d '/' -f 2-)"
                                mkdir -p "${dir2}/${fat}" > /dev/null
                                cp "${file}" "${dir2}/${fat}"
                        fi
                done < <(cat "${hidden}")
done < <(find "${dir1}" -type f -not -name "*.swp")


rm "${hidden}"
