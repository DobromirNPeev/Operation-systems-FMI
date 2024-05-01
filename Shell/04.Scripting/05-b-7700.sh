#!/bin/bash

if [ $# -ne 2 ];then
        echo "Invalid number of elements"
        exit 1
fi

if ! [ -d "${1}" ];then
        echo "Not a directory"
        exit 2
fi

if ! [[ "${2}" =~ ^[0-9]+$ ]];then
        echo "Not a number"
        exit 3
fi

sum=0
dir="${1}"
num="${2}"

while read -r file;do
        size=$(stat -c "%s" $file)
        sum=$((sum+size))
done < <(find "${dir}" -maxdepth 1 -mindepth 1 -type f -size +${num}c)

echo $sum
