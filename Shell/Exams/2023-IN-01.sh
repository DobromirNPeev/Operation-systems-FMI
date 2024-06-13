#!/bin/bash

if [[ -z "${CTRSLOTS}" ]];then
        CTRSLOTS=0
fi


if [[ "${#}" -eq "1" ]];then
        comm="${1}"
        if [[ "${comm}" == "autoconf" ]];then
                echo "yes"
                exit 0
        elif [[ "${comm}" == "config" ]];then
                echo "graph_title SSA drive tempratures"
                echo "graph_vlabel Celsius"
                echo "graph_category sensors"
                echo "graph_info This graph shows SSA drive temp"
                temp=$(mktemp)
                for x in "${CTRSLOTS}";do
                        ssascli ctrl slot=x pd all show detail > "${temp}"
                        c="${x}"
                        mmm="$(cat "${temp}" | head -n 1 | awk '{print $3}')"
                        while read arr;do
                                if echo "${arr}"| grep -q "Array";then
                                        a="$(echo "${arr}" | cut -d ' ' -f 2)"
                                elif echo "${arr}" | grep -q "Unassigend";then
                                        a="UN"
                                else
                                        if echo "${arr}" | grep -q "physicaldrive";then
                                                ppp="$(echo "${arr}" | cut -d ' ' -f 2 | sed 's/://g')"
                                                qqq="$(echo "${arr}" | cut -d ' ' -f 2)"
                                                id="SSA${c}${mmm}${a}${ppp}"
                                                label="SSA${c} ${mmm} ${a} ${qqq}"
                                                echo "${id}.label ${label}"
                                                echo "${id}.type GAUGE"
                                        fi
                                fi
                        done < <(cat "${temp}" | tail -n +2)
                done
                rm "${temp}"
        else
                echo "invalid arg"
                exit 1
        fi
elif [[ "${#}" -eq 0 ]];then
                for x in "${CTRSLOTS}";do
                        ssascli ctrl slot=x pd all show detail > "${temp}"
                        c="${x}"
                        mmm="$(cat "${temp}" | head -n 1 | awk '{print $3}')"
                        while read arr;do
                                if echo "${arr}"| grep -q "Array";then
                                        a="$(echo "${arr}" | cut -d ' ' -f 2)"
                                elif echo "${arr}" | grep -q "Unassigend";then
                                        a="UN"
                                else
                                        if echo "${arr}" | grep -q "physicaldrive";then
                                                ppp="$(echo "${arr}" | cut -d ' ' -f 2 | sed 's/://g')"
                                                qqq="$(echo "${arr}" | cut -d ' ' -f 2)"
                                                id="SSA${c}${mmm}${a}${ppp}"
                                                label="SSA${c} ${mmm} ${a} ${qqq}"
                                                #echo "${id}.label ${label}"
                                                #echo "${id}.type GAUGE"
                                        elif echo "${arr}" | grep -q "Current Temperature";then
                                                temperature="$(echo "${arr}" | cut -d ' ' -f 4)"
                                                echo "${id}.value ${temperature}"
                                        fi
                                fi
                        done < <(cat "${temp}" | tail -n +2)
                done
                rm "${temp}"
else
        echo "Invalid number of args"
        exit 2
fi
