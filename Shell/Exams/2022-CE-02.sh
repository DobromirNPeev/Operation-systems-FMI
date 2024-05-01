#!/bin/bash

if [[ "${#}" -ne 1 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

name="${1}"

state="$(grep "${name}" "example-wakeup" | awk '{print $3}')"

if [[ "${state}" == "*enabled" ]];then
        echo "${name}" > "example-wakeup"
fi
