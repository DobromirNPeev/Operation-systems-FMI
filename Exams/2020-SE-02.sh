#!/bin/bash

if [[ "${#}" -ne 1 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -f "${1}" ]];then
        echo "Not a file"
        exit 2
fi

file="${1}"

sites="$(cat "${file}" | cut -d ' ' -f 2 | sort | uniq -c | sort -k 1 -t ' ' -rn | head -n 3 | awk '{print $2}')"


while read site;do
        count_http2="$(cat "${file}" | grep -F "${site}" | grep -F "HTTP/2.0" | wc -l)"
        count_other="$(cat "${file}" | grep -F "${site}" | grep -v -F "HTTP/2.0" | wc -l)"
        echo "${site} HTTP/2.0: $count_http2 non-HTTP/2.0: $count_other"
done < <(echo "${sites}")
#echo "${sites}"

clients="$(cat "${file}" | cut -d ' ' -f 1 | sort | uniq)"
clients_count="$(mktemp)"

while read client;do
        count="$(cat "${file}" | grep -F "${client}" | awk '$9 > 302' | wc -l)"
        #echo "${count}"
        echo "${count} ${client}" >> "${clients_count}"
done < <(echo "${clients}")

cat "${clients_count}" | sort -k 1 -t ' ' -rn | head -n 5

rm "${clients_count}"
