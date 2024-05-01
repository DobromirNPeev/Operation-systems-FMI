#!/bin/bash

if [[ "${1}" == "-n" ]];then
        if [[ ! "${2}" =~ [0-9]+ ]];then
                echo "Not an number"
                exit 2
        fi
        N="${2}"
        shift
        shift
else
        N=10
fi

for file in "${@}";do
        if [[ ! -f "${file}" || ! "${file}" =~ .*\.log ]];then
                echo "Invalid argument"
                exit 1
        fi
done

all_content="$(mktemp)"

for file in "${@}";do
        file_content="$(cat "${file}")"
        idf="$(echo "${file}"  | sed -E 's/\.log//')"
        echo "${file_content}" | sed -E "s/(^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}) (.*:.*)/\1 ${idf} \2/" >> "${all_content}"
        #data="$(cut -d ' ' -f 3- "${file}")"
done

cat "${all_content}" | sort | head -n "${N}"
