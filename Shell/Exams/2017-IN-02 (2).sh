#!/bin/biash

if [[ "${#}" -ne 2 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ "$(whoami)" != "root" ]];then
        echo "Script is not executed by root"
        exit 2
fi

user="${1}"
user_file="$(mktemp)"
count_user="$(ps -u "${user}" -o pid= | wc -l)"

ps -e -o user= | grep -v "${user}" | sort | uniq -c | xargs -L 1 > "${user_file}"

while read count user1;do
        if [[ "${count}" -gt "${count_user}" ]];then
                echo "${count} ${user1}"
        fi
done < <(cat "${user_file}")

echo "${count_user} ${user}" >> "${user_file}"
count_user=$((count_user+1))

sum=0
while read count user1;do
        sum=$((sum + $(ps -u "${user1}" -o times= | tr '\n' ' ' |xargs | tr ' ' '+' | bc)))
done < <(cat "${user_file}")

avg_time="$(echo "scale=2; ${sum}/${count_user}" | bc)"
echo "Average time: ${avg_time}"

avg_time=$((avg_time*2))

while read pid time;do
        if [[ "${time}" -gt "${avg_time}" ]];then
                #kill -TERM "${pid}"
                sleep 2
                #kill -KILL "${pid}"
        fi
done < <(ps us "${user}" -o pid=,times=)

rm "${user_file}"
