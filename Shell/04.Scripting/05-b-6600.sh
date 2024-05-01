#!/bin/bash

if [ $# -ne 1 ];then
        echo "Invalid number of arguments"
        exit 1
fi

if ! [ -d "${1}" ];then
        echo "Not a directory"
        exit 2
fi

if ! [ -w "${1}" ];then
        echo "Cannot remove"
        exit 3
fi

dir="${1}"

find "${dir}" -maxdepth 1 -type f 2>/dev/null | while read -r file;do
        find "${dir}" -maxdepth 1 -type f | while  read -r file2;do
                if [ "${file}" != "${file2}" ] &&  diff -q "${file}" "${file2}" >/dev/null 2>&1;then
                        if [[ "${file}" > "${file2}" ]];then
                                rm "${file}"
                        else
                                rm "${file2}"
                        fi
                        break
                fi
        done
done
