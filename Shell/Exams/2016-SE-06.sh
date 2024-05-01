#!/bin/bash

if [[ $# -ne 1 ]];then
        echo "Invalid number of argument"
        exit 1
fi

if [[ ! -f "${1}" ]];then
        echo "Not a file"
        exit 2
fi

content="$(cat "${1}")"
echo "${content}" | sed -E 's/^.* (")/\1/' | awk -v 'count=1' '{print count ". " $0;count+=1}' | sort -k 2 -t ' '
