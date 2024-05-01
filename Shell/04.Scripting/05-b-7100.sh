#!/bin/bash

if [ $# -ne 2 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if ! [ -d "${1}" ];then
        echo "Not a directory"
        exit 2
fi

if ! [[ "${2}" =~ [0-9]+ ]];then
        echo "Not a number"
        exit 3
fi

dir="${1}"
number="${2}"

find "${dir}" -maxdepth 1 -type f -size +$number
