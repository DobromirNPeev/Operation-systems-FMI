#!/bin/bash

if [ $# -ne 1 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if ! cat /etc/passwd | cut -d ':' -f 1 | grep -F -q "${1}";then
        echo "Non-existent user"
        exit 1
fi

user="${1}"
processes=$(ps -u "${user}" -o rss=,vsz= | tr -s ' ' | sed -E 's/^ *//' |sort -k 2 -t ' ' -n)

echo "${processes}" | while read line;do
        rss=$(echo "${line}" | cut -d ' ' -f 1)
        vsz=$(echo "${line}" | cut -d ' ' -f 2)
        res=$(echo "scale=2; $rss/$vsz" | bc )
        echo "Ratio: ${res}"
done
