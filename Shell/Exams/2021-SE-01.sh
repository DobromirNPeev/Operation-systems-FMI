#!/bin/bash


me="$(whoami)"

if [[ "${me}" != "oracle" || "${me}" != "grid" ]];then
        echo "invalid user"
        exit 1
fi

if [[ -z "${ORACLE_HOME}" ]];then
        echo "should have oracle_home"
        exit 2
fi

bin="${ORACLE_HOME}/bin/adrci"

if [[ ! -f "${bin}" ]];then
        echo "should have adrci"
        exit 3
fi

adrci exec="show homes" | while read home;do
        if [[ "${home}" == "No ADR homes are set" ]];then
                echo "no homes"
                exit 4
        fi
        if [[ "${home}" == "ADR homes" ]];then
                continue
        fi
        homes="$(echo "${homes}" | xargs)"
        bytes="$(stat -c %s )"
        megabytes="$(echo 1024*1024 | bc)"
        bytes="$(echo ${bytes}/${megabytes} | bc)"
        echo "${bytes} ${diag_dest}/${home}"
done
