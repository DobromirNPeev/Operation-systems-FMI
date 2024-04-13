#!/bin/bash

if [[ "$(whoami)" != "root" ]];then
    echo "User is not root"
    exit 1
fi

users="$(ps -e -o user= | grep -v -F "root" | sort | uniq)"

needed_users=""
sum_root="$(ps -u "root" -o user=,rss= | awk '{sum+=$2} END {print sum}')"
#Iecho "$sum_root"
while read user;do
        dir="$(cat /etc/passwd | grep -F "${user}" | cut -d ':' -f 6)"
        if [[ ! -d "${dir}" ]];then
                needed_users+="${user}\n"
        else
                owner="$(stat -c "%U" "${dir}")"
                if [[ "${owner}" != "${user}" ]];then
                        needed_users+="${user}\n"
                        continue
                fi
                perm="$(stat -c "%A" "${dir}" | cut -c 3)"
                if [[ "${perm}" != "w" ]];then
                        needed_users+="${user}\n"
                        continue
                fi
        fi
done <<< "${users}"



while read user;do
        if [[ -z "${user}" ]];then
                continue
        fi
        sum_user_mem="$(ps -u "${user}" -o rss= | awk '{sum+=$1} END {print sum}')"
        if [[ "${sum_user_mem}" -gt ]];then
                #kilLall "${user}"
        fi
done < <(echo -e "${needed_users}")
