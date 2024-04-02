#!/bin/bash

if [ $# -ne 3 ];then
        echo 'Invalid number of arguments'
        exit 1
elif ! [[ "${1}" =~ ^-?[0-9]+$ ]] || ! [[ "${2}" =~ ^-?[0-9]+$ ]] || ! [[ "${3}" =~ ^-?[0-9]+$ ]];then
        echo 'Invalid arguments'
        exit 3
elif [ "${2}" -gt "${3}" ];then
        echo "Invalid boundries"
        exit 2
elif [ "${1}" -lt "${2}" ] || [ "${1}" -gt "${3}" ];then
        echo "Not in interval"
        exit 1
elif [ "${1}" -ge "${2}" ] || [ "${1}" -le "${3}" ];then
        echo "In interval"
        exit 0
fi
