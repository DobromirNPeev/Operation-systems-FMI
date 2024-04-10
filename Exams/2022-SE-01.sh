#!/bin/bash

if [[ "${#}" -ne 1 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -f "${1}" ]];then
        echo "Not a file"
        exit 2
fi

config="${1}"

while read line;do
        name="$(echo "${line}" | awk '{print $1}')"
        state="$(echo "${line}" | awk '{print $2}')"
        if  grep -q "${name}" "example-wakeup";then
                og_state=$(grep - q "${name}" "example-wakeup" | awk '{print $3}')
                if [[ "${og_state}" == "${state}" ]];then
                        continue
                else
                        echo "${name}" > "example-wake"
                fi
        else
                echo "${name} doesn't exist"
        fi
        echo "${line}"
done < <(cat "${config}" | sed -E 's/#.*//' | grep -v -E '^$')
