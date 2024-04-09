#!/bin/bash

numbers_files="$(mktemp)"

while read line;do
        if echo "${line}" | grep -E -q -o "^-?[0-9]+$";then
                echo "${line}" >> "${numbers_files}"
        fi
done

sum_number_files="$(mktemp)"

while read number;do
        sum=0
        number_copy="$(echo "${number}" | sed -E 's/-?([0-9])/\1 /g')"
        for digit in $(echo "${number_copy}");do
                sum=$((sum+digit))
        done
        echo "${number} ${sum}" >> "${sum_number_files}"
done < <(cat "${numbers_files}")

max="$(cat "${sum_number_files}" | sort -rn -k 2 -t ' ' | head -n 1 | cut -d ' ' -f 2)"
small_numbers="$(mktemp)"

while read number_sum;do
        if [[ "$(echo "${number_sum}" | cut -d ' ' -f 2)" -eq "${max}" ]];then
                echo "${number_sum}" >> "${small_numbers}"
        fi
done < <(cat "${sum_number_files}")

cat "${small_numbers}" | sort -n -k 1 -t ' ' | uniq | head -n 1 | cut -d ' ' -f 1

rm "${number_files}"
rm "${sum_number_files}"
rm "${small_numbers}"
