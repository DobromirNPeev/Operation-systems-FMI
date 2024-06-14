#!/bin/bash

if [[ $# -ne 1 ]];then
        echo "should have 1 param"
        exit 5
fi

if [[ ! "${1}" =~ [0-9]+ ]];then
        echo "param should be a number"
        exit 6
fi

if [[ "${1}" -lt 2 ]];then
        echo "should be larger than 2"
        exit 7
fi

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

time="${1}"
minutes="$(echo "${time}*60" | bc)"

adrci exec="SET BASE ${diag_dest}; SHOW HOMES" | while read home;do
        if [[ "${home}" == "No ADR homes are set" ]];then
                echo "no homes"
                exit 4
        fi
        if [[ "${home}" =~ ^[^\/]*\/(crs|tnslsnr|kfod|asm|rdms) ]];then
                adrci exec="SET BASE ${diag_dest};SET HOMEPATH ${home}; PURGE -AGE ${minutes}"
        fi
done
