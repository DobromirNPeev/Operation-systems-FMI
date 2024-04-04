#!/bin/bash

if [ $# -ne 3 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if ! [ -f "${1}" ];then
        echo "Not a file"
fi

if ! [[ "${3}" =~ "${3}" ]];then
        echo "File doesn't contain string 2."
        exit 2
fi

value_string1=$(cat "${1}"  | grep -F "${2}=" | sed -E "s/^"${2}"=(.*)$/\1/")
value_string2=$(cat "${1}"  | grep -F "${3}=" | sed -E "s/^"${3}"=(.*)$/\1/")
res="${value_string1} ${value_string2}"
res="$(echo "${res}" | sed 's/ /\n/g' | sort | uniq | tr '\n' ' ')"
sed -i -E "s/${3}=.*/${3}=${res}/" "${1}"

