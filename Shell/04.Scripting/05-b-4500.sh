#!/bin/bash

if [ $# -ne 1 ];then
        echo 'Invalid number of arguments'
        exit 1
fi

user_id="${1}"

if  ! cat /etc/passwd | grep -F -q "${user_id}" ;then
        echo 'Non-existent user'
        exit 2
fi

while sleep 1;do
        if who | grep -F -q "${user_id}";then
                echo "${user_id} logged in"
                exit 0
        fi
done
