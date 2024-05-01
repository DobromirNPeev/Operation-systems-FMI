#!/bin/bash

if [[ "$#" -ne 2 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -d "${1}" ]];then
        echo "Not a dir"
        exit 2
fi

dir="${1}"
output="${2}"
temp_file="$(mktemp)"

while read file;do
        content="$(cat "${file}" | head -n 1)"
        if echo "${content}" | grep -q ":";then
                classname="$(echo "${content}" | cut -d ':' -f 1 | awk '{print $2}')"
                parent_classes="$(echo "${content}" | cut -d ':' -f 2 | tr ',' '\n')"
                echo "${classname}" >> "${temp_file}"
                while read parent;do
                        parent="$(echo "${parent}" | awk '{print $2}')"
                        if ! grep -q -E "\<${parent}\>" "${output}";then
                                echo "${parent}" >> "${temp_file}"
                        fi
                        echo "${parent} -> ${classname}" >> "${temp_file}"
                done < <(echo "${parent_classes}")
        else
                classname="$(echo "${content}" | awk '{print $2}')"
                echo "${classname}" >> "${output}"
        fi
done < <(find "${dir}" -type f -name '*.h')


sorted="$(mktemp)"

cat "${temp_file}" >> "${sorted}"
cat "${sorted}" | sort | uniq > "${temp_file}"

dag-ger "${temp_file}" > "${output}"
