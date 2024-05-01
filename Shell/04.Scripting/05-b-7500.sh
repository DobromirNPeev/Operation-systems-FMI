#!/bin/bash

if [ $# -ne 0 ] && [ $# -ne 2 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if [ $# -eq 2 ];then
        if ! [[ "${1}" =~ ^[0-9]+$ ]] || ! [[ "${2}" =~ ^[0-9]+$ ]];then
                echo "Not numbers"
                exit 2
        fi
        if [ ${1} -gt ${2} ];then
                echo "Invalid interval"
                exit 3
        fi
        a=$1
        b=$2
else
        a=1
        b=100
fi

random=$(((RANDOM % $b)+$a))
tries=0
while read -p "Guess ? " guess;do
        if ! [[ "${guess}" =~ ^[0-9]+$ ]];then
                echo "Enter a number"
                continue
        fi
        tries=$((tries+1))
        if [ "${guess}" -gt "${random}" ];then
                echo "...smaller!"
        elif [ "${guess}" -lt "${random}" ];then
                echo "...bigger!"
        else
                echo "RIGHT! Guessed ${random} in ${tries} tries"
                exit 0
        fi
done
