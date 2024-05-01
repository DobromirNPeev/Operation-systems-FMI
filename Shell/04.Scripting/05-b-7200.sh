#!/bin/bash

for entry in "${@}";do
        if ! [ -f "${entry}" ] && ! [ -d "${entry}" ];then
                echo "Invalid argument"
                continue
        fi
        if [ -f "${entry}" ] && ! [ -r "${entry}" ];then
                echo "Unreadble"
        elif [ -f "${entry}" ] && [ -r "${entry}" ];then
                echo "Readble"
        elif [ -d "${entry}" ];then
                count=$(find "${entry}" -mindepth 1 -maxdepth 1 -type f | wc -l)
                res="$(find "${entry}" -mindepth 1 -maxdepth 1 -type f -size -${count}c)"
                echo "${res}"
        fi
done
