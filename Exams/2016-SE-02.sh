#!/bin/bash

if [[ "${#}" -ne 2 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! "${1}" = ^[0-9]+$ ]];then
        echo "Not a number"
        exit 2
fi

if [[ ! "$(whoami)" == "root" ]];then
        echo "User is not root"
        exit 3
fi

users="$(mktemp)"
number="${1}"


ps -e -o user= | sort | uniq > "${users}"

while read user;do
        sum="$(ps -u "${user}" -o rss= |xargs | tr ' ' '+' | bc)"
        if [[ "${sum}" -gt "${number}" ]];then
                highest_rss_process="$(ps -u "${user}" -o rss=,pid= | sort -k 1 -t ' ' -rn | head -n 1 | awk '{print $2}')"
                #kill -TERM "${highest_rss_process}"
                sleep 2
                #kill -KILL "${highes_rss_process}"
        fi
done < <(cat "${users}")

rm "${users}"
