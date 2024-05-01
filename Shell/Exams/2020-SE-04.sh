#!/bin/bash

if [[ "$#" -ne 2 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -d "${1}" || ! -d "${2}" ]];then
        echo "Not a directory"
        exit 2
fi

src="${1}"
dst="${2}"


#clean="$(echo "${files}" | sed -E 's/^ +//g' | sed -E 's/ +(\.jpg)$/\1/' | sed -E 's/ +/ /g')"

mkdir "${dst}"

while read file;do
        title="$(basename "${file}" | sed -E 's/\([^)]*\)//g' | tr -s ' ' | sed -E 's/ *\.jpg$//' | sed 's/^ *//')"
        album="$(echo "${file}" | grep -E -o '\([^)]*\)' | tail -n 1 | sed -E 's/^\( *//' | sed -E 's/ *\)$//')"
        if [[ -z "${album}" ]];then
                album="misc"
        fi
        date="$(stat -c "%y" "${file}" | cut -d ' ' -f 1)"
        hash="$(sha256sum "${file}" | cut -c 1-16)"
        #echo "${title} ${album} ${date} ${hash}"

        mkdir "${dst}/images" 2>/dev/null
        mkdir -p "${dst}/by-date/${date}/by-album/${album}/by-title"
        mkdir -p "${dst}/by-date/${date}/by-title/${title}.jpg"
        mkdir -p "${dst}/by-album/${album}/by-date/${date}/by-title/${title}.jpg"
        mkdir -p "${dst}/by-album/${album}/by-title/${title}.jpg"
        mkdir -p "${dst}/by-title/${title}.jpg"

        cp "${file}" "${dst}/images/${hash}.jpg"
        ln -s "${dst}/${hash}.jpg" "${dst}/by-date/${date}/by-album/${album}/by-title/${title}.jpg"
        ln -s "${dst}/${hash}.jpg" "${dst}/by-date/${date}/by-title/${title}.jpg"
        ln -s "${dst}/${hash}.jpg" "${dst}/by-album/${album}/by-date/${date}/by-title/${title}.jpg"
        ln -s "${dst}/${hash}.jpg" "${dst}/by-album/${album}/by-title/${title}.jpg"
        ln -s "${dst}/${hash}.jpg" "${dst}/by-title/${title}.jpg"

done < <(find "${src}" -type f -name '*.jpg')
