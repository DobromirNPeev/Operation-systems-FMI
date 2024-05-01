#!/bin/bash

if [ $# -ne 1 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if ! [[ "${1}" =~ ^-r$|^-x$|^-b$|^-g$ ]];then
        echo "Invalid argument"
        exit 2
fi

color="${1}"
while read -p "Enter string:" input;do
        if [ $input == "exit" ];then
                exit 0
        fi
        if [ "${1}" == "-x" ];then
                echo "${input}"
        elif [ $color  == "-r" ];then
                echo -e "\033[0;31m ${input}"
                color="-g"
                echo -e '\033[0m'
                continue
        elif [ $color == "-g" ];then
                echo -e "\033[0;32m ${input}"
                color="-b"
                echo -e '\033[0m'
                continue
        elif [ $color == "-b" ];then
                echo -e "\033[0;34m ${input}"
                color="-r"
                echo -e '\033[0m'
                continue
        fi
done

echo -e '\033[0m'
