#!/bin/bash

numbers_file=$(mktemp)

while read  line ;do
        if echo "${line}" | grep -E -q "^-?[0-9]+";then
                echo "${line}" >> "${numbers_file}"
        fi
done

max="$(sort -rn "${numbers_file}"| uniq  | head -n 1)"
while read number;do
        if [[ "${number}" =~ ^[0-9]+$ ]];then
                if [[ "${number}" == "${max}" ]];then
                        echo "${number}"
                fi
        else
                removed_minus="$(echo "${number}" | sed 's/-//')"
                if [[ "${removed_minus}" == "${max}" ]];then
                        echo "${number}"
                fi
        fi
done < <(cat "${numbers_file}")

rm "${numbers_file}"
