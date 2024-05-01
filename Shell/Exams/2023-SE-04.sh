#!/bin/bash

dir="${1}"
count=0
save_bytes=0


while read file;do
        samefiles="$(mktemp)"
        while read file2;do
                if [[ ! -f "${file}" || ! -f "${file2}" ]];then
                        continue
                fi
                if [[ "${file}" == "${file2}" ]];then
                        continue
                fi
                #echo "$(sha256sum "${file}") $(sha256sum "${file2}")"
                if [[ "$(sha256sum "${file}" | cut -d ' ' -f 1)" == "$(sha256sum "${file2}" | cut -d ' ' -f 1)" ]];then
                        echo "${file2}" >> "${samefiles}"
                fi
        done < <(find "${dir}" -type f)
        if [[ -s "${samefiles}" ]];then
                cp "${file}" "${dir}/new_file${count}"
                while read file2;do
                        saved_bytes=$((saved_bytes+$(stat -c "%s" "${file2}")))
                        rm "${file2}"
                        ln -s "${dir}/new_file${count}" "${file2}"
                done < <(cat "${samefiles}")
                saved_bytes=$((saved_bytes+$(stat -c "%s" "${file}")))
                rm "${file}"
                ln -s "${dir}/new_file${count}" "${file}"
                count=$((count+1))
        fi
        rm "${samefiles}"
done < <(find "${dir}" -type f)

echo "Deduplicated groups:${count}"
echo "Freed bytes:${saved_bytes}"
