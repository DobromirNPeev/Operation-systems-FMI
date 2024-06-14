#!/bin/bash

curr_date="$(date +"%Y%m%d")"

for file in "${@}";do
        if [[ ! -f "${file}" ]];then
                echo "not a file"
                exit 1
        fi
        lines_count="$(cat "${file}" | wc -l)"
        if [[ "${lines_count}" -eq 1 ]];then
                file_serial="$(cat "${file}" | cut -d ' ' -f 7)"
                file_date="$(echo "${file_serial}" | head -c 8)"
                if [[ "${file_date}" -lt "${curr_date}" ]];then
                        sed -i "s/${file_serial}/${curr_date}00/" "${file}"
                elif [[ "${file_date}" -eq "${curr_date}" ]];then
                        tt="$(echo ${file_serial} | tail -c 2)"
                        tt="$(echo ${tt}+1 | bc)"
                        if [[ "${tt}" -gt 99 ]];then
                                echo "Error in ${file}"
                                continue
                        fi
                        if [[ "${tt}" -lt 10 ]];then
                                tt="0${tt}"
                        fi
                        sed -i "s/${file_serial}/${file_date}${tt}/" "${file}"
                fi
        else
                file_serial="$(cat "${file}" | head -n 2 | tail -n 1 | cut -d ';' -f 1 | xargs)"
                file_date="$(echo "${file_serial}" | head -c 8)"
                if [[ "${file_date}" -lt "${curr_date}" ]];then
                        sed -i "s/${file_serial}/${curr_date}00/" "${file}"
                elif [[ "${file_date}" -eq "${curr_date}" ]];then
                        tt="$(echo ${file_serial} | tail -c 2)"
                        tt="$(echo ${tt}+1 | bc)"
                        if [[ "${tt}" -gt 99 ]];then
                                echo "Error in ${file}"
                                continue
                        fi
                        if [[ "${tt}" -lt 10 ]];then
                                tt="0${tt}"
                        fi
                        sed -i "s/${file_serial}/${file_date}${tt}/" "${file}"
                fi
        fi
done
