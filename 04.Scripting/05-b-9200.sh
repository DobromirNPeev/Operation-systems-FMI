#!/bin/bash

for file in "${@}";do
        if [ "${file}" == "${1}" ] && [ "${file}" == "-r" ];then
                continue
        fi
        if ! [ -f "${file}" ] && ! [ -d "${file}" ];then
                echo "Invalid arguments"
                exit 1
        fi
done



for file in "${@}";do
        if [ -f "${file}" ];then
                rm "${file}"
                echo "$(date +"[%Y-%m-%d %H:%M:%S]") Removed ${file}" >> "remove.log"
        elif [ -d "${file}" ];then
                num_of_files=$(find "${file}" -mindepth 1 -maxdepth 1 | wc -l)
                if [ $num_of_files -eq 0 ];then
                        rmdir "${file}"
                        echo "$(date +"[%Y-%m-%d %H:%M:%S]") Removed ${file}" >> "remove.log"
                elif [ "${1}" == "-r" ];then
                        rm -r "${file}"
                        echo "$(date +"[%Y-%m-%d %H:%M:%S]") Remove ${file} recursively" >> "remove.log"
                fi
        fi
done
