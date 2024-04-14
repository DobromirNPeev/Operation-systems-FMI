#!/bin/bash

if [[ "${#}" -ne 3 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -f "${1}" ]];then
        echo "Not a file"
        exit 2
fi

if [[ ! "${2}" =~ ^[a-zA-Z0-9_]+$ || ! "${3}" =~ ^[a-zA-Z0-9_]+$ ]];then
        echo "Invalid format"
        exit 3
fi

conf="${1}"
key="${2}"
value="${3}"

if grep -E -q "^ *\<${key}\> *=" "${conf}";then
        line="$(grep -E -n "^ *\<${key}\> *=" "${conf}")"
        content="$(echo "${line}" | cut -d ':' -f 2)"
        og_value="$(echo "${content}" | cut -d '=' -f 2 | sed -E 's/#.*//' | xargs)"
        if [[ "${value}" != "${og_value}" ]];then
                sed -i -E "s/${content}/# ${content} # edited at $(date) by $(whoami)/" "${conf}"
                line_number="$(echo "${line}" | cut -d ':' -f 1)"
                line_number=$((line_number+1))
                sed -i -E "${line_number}i\\${key} = ${value} # added at $(date) by $(whoami)" "${conf}"
        fi
else
        echo "${key} = ${value} # added at $(date) by $(whoami)" >> "${conf}"
fi
