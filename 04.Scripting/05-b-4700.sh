#!/bin/bash

if [ $# -gt 2 ] || [ $# -eq 0 ];then
        echo "Invalid number of arguments"
        exit 1
fi

sep=' '

if [ $# -eq 2 ];then
        if ! [[ "${2}" =~ ^.$ ]];then
                echo "Invalid separator"
                exit 2
        fi
        sep="${2}"
fi

        # Consider number is non-negative
        if ! [[ "${1}" =~ ^[0-9]+$ ]];then
                echo 'Not a number'
                exit 1
        fi

        numbers="$(echo "${1}" | sed -E 's/([0-9])/\1\n/g')"
        length=$(echo "${numbers}" | wc -l)
        res=""
        for number in $numbers;do
                res+="${number}"
                length=$((length-1))
                if [ $((length % 3)) -eq 0 ] && [ "${length}" -gt 0 ];then
                        res+="${sep}"
                fi
        done
        echo "${res}"
