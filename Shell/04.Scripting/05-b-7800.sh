#!/bin/bash

if [ $# -ne 0 ];then
        echo "No need arguments"
        exit 1
fi
sum=0
while read -d ':' dir;do
        while read -r file;do
                if [ -x "${file}" ];then
                        sum=$((sum+1))
                fi
        done < <(find "${dir}" -type f)
done < <(echo "${PATH}")

echo "${sum}"
