#!/bin/bash

if [[ "$(whoami)" != "root" ]];then
        echo "User is not root"
        exit 1
fi

while read user;do
        username="$(echo "${user}" | cut -d ':' -f 1)"
        home_dir="$(echo "${user}" | cut -d ':' -f 6)"
        #echo "${perm}"
        if [[ ! -e "${home_dir}" ]];then
                echo "${username} does not have home directory"
                continue
        fi
        perm="$(stat -c "%A" "${home_dir}" | cut -c 3)"
        if [[ "${perm}" != "w" ]];then
                echo "${username} cannot write"
        fi
done < <(cat /etc/passwd)
