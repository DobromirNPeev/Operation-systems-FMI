#!/bin/bash

if ! [ -d "${1}" ] || ! [ -d "${2}" ];then
        echo "Invalid arguments"
        exit 1
fi

source="${1}"
dest="${2}"

uniq_extents=$(find "${source}" -type f | grep -E "^.*\..*$" |sed -E 's/^.*\.//' | sort | uniq)

while read extent;do
        mkdir -p "${dest}/${extent}"
done < <(echo "${uniq_extents}")

while read extent;do
        while read file;do
                mv "${file}" "${dest}/${extent}"
        done < <(find "${source}" -type f | grep -F "${extent}")
done < <(echo "${uniq_extents}")
