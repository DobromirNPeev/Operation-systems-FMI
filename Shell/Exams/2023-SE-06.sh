#!/bin/bash

if [[ "${#}" -ne 2 ]];then
        echo "Invalid number of agrs"
        exit 1
fi

if [[ ! -d "${1}" ]];then
        echo "arg 1 not a dir"
        exit 2
fi

if [[ -d "${2}" ]];then
        echo "arg 1 not a dir"
        exit 2
fi

camera="${1}"
lib="${2}"

dates=$(mktemp)

find "${camera}" -type f -name "*.jpg" -printf "%TF\n" | sort | uniq > "${dates}"

mkdir "${lib}"

first=""
last=""
next_day=""

while read date;do
        if [[ -z "${first}" && -z "${last}" ]];then
                first="${date}"
                last="${date}"
                next_day="$(date -d "${date} + 1 day" +'%Y-%m-%d')"
                continue
        fi
        echo "${date} ${next_day}"
        if [[ "${date}" != "${next_day}" ]];then
                mkdir -p "${lib}/${first}_${last}"
                first="${date}"
                last="${date}"
                next_day="$(date -d "${date} + 1 day" +'%Y-%m-%d')"
        else
                last="${next_day}"
                next_day="$(date -d "${date} + 1 day" +'%Y-%m-%d')"
        fi
done < <(cat "${dates}")

names_times=$(mktemp)

find "${camera}" -type f -name "*.jpg" -printf "%f %TF %TT\n"  > "${names_times}"

while read -r name date time;do
        #echo "${date}"
        date_s="$(date -d "${date}" +%s)"
        while read date1;do
                lhs="$(echo "${date1}" | cut -d '_' -f 1)"
                rhs="$(echo "${date1}" | cut -d '_' -f 2)"
                date_lhs="$(date -d "${lhs}" +%s)"
                date_rhs="$(date -d "${rhs}" +%s)"
                #echo "${date_s} ${date_lhs} ${date_rhs}"
                if [[ "${date_s}" -ge "${date_lhs}" && "${date_s}" -le "${date_rhs}" ]];then
                        mv "${name}" "${lib}/${date1}/${date}_${time}.jpg"
                        break
                fi
        done < <(find "${lib}" -mindepth 1 -type d -printf "%f\n")
done < <(cat "${names_times}")

rm "${names_times}"
rm "${dates}"
