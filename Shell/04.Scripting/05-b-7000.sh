#!/bin/bash

read -p "Enter string:" string

for file in "${@}";do
        count=$(cat "${file}" | grep -F "${string}" | wc -l)
        echo "${count} occurences in ${file}"
done
