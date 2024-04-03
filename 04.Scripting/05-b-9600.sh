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
                gzip -c "${file}" > $BACKUP_DIR/${file}_$(date +"%Y-%m-%d-%H-%M-%S").gz
                rm "${file}"
        elif [ -d "${file}" ];then
                num_of_files=$(find "${file}" -mindepth 1 -maxdepth 1 | wc -l)
                if [ "${num_of_files}" -eq 0 ];then
                        tar -czf "$BACKUP_DIR/${file}_$(date +"%Y-%m-%d-%H-%M-%S").tgz" "${file}"
                        rmdir "${file}"
                elif [ "${1}" == "-r" ];then
                        tar -czf "$BACKUP_DIR/${file}_$(date +"%Y-%m-%d-%H-%M-%S").tgz" "${file}"
                        rm -r "${file}"
                fi
        fi
done
