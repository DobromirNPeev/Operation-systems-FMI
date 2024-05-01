#!/bin/bash

read file_name
read string

if [ ! -e "${file_name}" ] || [ ! -r "${file_name}" ];then
        echo 'Invalid input'
        exit 1
fi

cat "${file_name}" | grep -q "$string"
echo "${?}"
