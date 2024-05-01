#!/bin/bash

if [ $# -ne 3 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if [ ! -f $1 ] || [ ! -e $1 ] || [ ! -w $1 ];then
        echo "Invalid file"
        exit 1
fi

echo "${2}" | grep -E -q '.* .*'

if [ $? -ne 0 ];then
        echo 'Invalid fullname'
        exit 1
fi

file_name=$1
full_name=$2
nickname=$3

username="$(cat /etc/passwd | grep ":$full_name," | cut -d ':' -f 1)"

if [ $(echo "${username}" | wc -l) -gt 1 ];then
        echo "Choose one"
        echo "0 for exit"
        count=0
        while read line;do
                echo "${line} ${full_name} ${count}"
                arr[$count]="${line}"
                count=$((count+1))
        done < <(echo "${username}")
        read number
        if [ number -eq 0 ];then
                exit 0
        elif [ number -gt count ];then
                echo 'Invalid number'
                exit 1
        fi
        username=$arr["${line}"]
fi

if [ -n $username ];then
        echo "${nickname} ${username}" >> "$file_name"
        echo "${nickname} ${username} added to file"
fi
