#!/bin/bash

read file_name

if [ ! -e "${file_name}" ] || [ ! -f "${file_name}" ] || [ ! -r "${file_name}" ];then
        echo 'Invalid input'
        exit 1
fi

if echo "${file_name}" | grep -q -E '^.*\.c$'; then
        echo "Invalid format"
        exit 1
fi

max=0
count=0
while read line;do
        if echo "$line" | grep -q '{';then
                count=$((count+1))
        fi
        if echo "$line" | grep -q '}';then
                count=$((count-1))
        fi
        if [ $count -gt $max ];then
                max=$count
        fi

done < <(cat ${file_name})

echo "${max}"
