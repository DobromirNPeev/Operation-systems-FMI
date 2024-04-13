#!/bin/bash


if [[ "${#}" -eq 2 ]];then
        if [[ ! -d "${1}" ]];then
                echo "Not a directory"
                exit 2
        fi
        dir="${1}"
        number="${2}"
        files="$(mktemp)"
        find "${dir}" -type f -printf "%n %p\n" > "${files}"
        while read hardlinks file;do
                if [[ "${hardlinks}" -ge "${number}" ]];then
                        echo  "${file}"
                fi
        done < <(cat "${files}")
        rm "${files}"
elif [[ "${#}" -eq 1 ]];then
        if [[ ! -d "${1}" ]];then
                echo "Not a directory"
                exit 2
        fi
        dir="${1}"
        find "${dir}" -type l | while read symlink;do
                if [[  -e "${symlink}" ]];then
                        echo "${symlink}"
                fi
        done
else
        echo "Invalid number of arguments"
        exit 1
fi
