#!/bin/bash

if [ $# -ne 3 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if ! [ -f "${1}" ];then
        echo "Not a file"
        exit 2
fi

if ! grep "${3}=" "${1}";then
        echo "File doesn't contain string 2."
        exit 3
fi

#Better done with temporary files and named arguments
value_string1=$(cat "${1}"  | grep -F "${2}=" | sed -E "s/^"${2}"=(.*)$/\1/")
value_string2=$(cat "${1}"  | grep -F "${3}=" | sed -E "s/^"${3}"=(.*)$/\1/")
res="${value_string1} ${value_string2}"
res="$(echo "${res}" | sed 's/ /\n/g' | sort | uniq -c | xargs -L 1 )"

while read count term;do
        if [[ "${count}" -gt 1 && "$(echo "${value_string2}" | grep -F "${term}")" ]];then
                value_string2="$(echo "${value_string2}" | sed -E "s/ ?\<${term}\> ?//")"
                echo "${value_string2}"
        fi
done < <(echo "${res}")
sed -i -E "s/${3}=.*/${3}=${value_string2}/" "${1}"
