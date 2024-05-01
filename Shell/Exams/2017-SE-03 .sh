#!/bin/bash

if [[ "$(whoami)" != "root" ]];then
        echo "User is not root"
        exit 1
fi

users="$(mktemp)"

ps -e -o user= | sort | uniq > "${users}"

while read user;do
        count="$(ps -u "${user}" -o pid= | wc -l)"
        sum="$(ps -u "${user}" -o rss= | xargs | tr ' ' '+' | bc)"
        echo "${user}'s proccesses count:${count}"
        echo "${user}'s overall count:${sum}"
        avg_rss="$(echo "${sum}/${count}" | bc)"
        avg_rss=$((avg_rss*2))
        highest="$(ps -u "${user}" -o pid=,rss= | xargs -L 1 | sort -k 2 -t ' ' -rn | head -n 1)"
        highest_rss="$(echo "${highest}" | cut -d ' ' -f 2)"
        highest_pid="$(echo "${highest}" | cut -d ' ' -f 1)"
        echo "${highest}"
        if [[ "${highest_rss}" -gt "${avg_rss}" ]];then
                #kill -TERM "${highest_pid}"
                sleep 2
                #kill -KILL "${highest_pid}"
        fi
done < <(cat "${users}")
