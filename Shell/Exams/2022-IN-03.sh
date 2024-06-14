#!/bin/bash

options=""
args=""
filename=""
is_jar=0
saw_jar=0

for el in "${@}";do
        if [[ "${el}" == "-jar" ]];then
                saw_jar=1
                continue
        fi
        if [[ "${is_jar}" -eq 1 ]];then
                args+="${el} "
                continue
        fi
        if [[ -f "${el}" ]] && [[ "${el}" =~ ^.*\.jar ]];then
                if [[ "${saw_jar}" -eq 1 ]];then
                        is_jar=1
                        filename="${el}"
                else
                        echo ".jar should be after -jar"
                        exit 1
                fi
                continue
        fi
        if echo "${el}" | grep -q -E "^-D[^=]*=.*$";then
                if [[ "${saw_jar}" -eq 1 ]];then
                        options+="${el} "
                else
                        echo "should have seen -jar"
                        exit 2
                fi
                continue
        fi
        if echo "${el}" | grep -q -E "^-.*";then
                options+="${el} "
        fi
done

java ${options} -jar ${filename} ${args}
