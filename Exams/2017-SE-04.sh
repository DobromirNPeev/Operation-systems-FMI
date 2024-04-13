#!/bin/bash

if [[ "${#}" -eq 2 ]];then
        if [[ ! -d "${1}" ]];then
                echo "Not a directory or does not exist"
                exit 2
        fi
        dir="${1}"
        dest="${2}"
        count=0
        while read link;do
                if [[ -e "${link}" ]];then
                        echo "${link} -> $(readlink ${link})" >> "${dest}"
                else
                        count=$((count+1))
                fi
        done < <(find "${dir}" -type l 2>/dev/null)

        echo "Broken symlinks:${count}" >> "${dest}"
elif [[ "${#}" -eq 1 ]];then
        if [[ ! -d "${1}" ]];then
                echo "Not a directory or does not exist"
                exit 2
        fi
        dir="${1}"
        count=0
        while read link;do
                if [[ -e "${link}" ]];then
                        echo "${link} -> $(readlink ${link})"
                else
                        count=$((count+1))
                fi
        done < <(find "${dir}" -type l 2>/dev/null)
        echo "Broken symlinks:${count}"
else
        echo "Invalid number of arguments"
        exit 1
fi
