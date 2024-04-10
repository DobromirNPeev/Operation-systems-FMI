#!/bin/bash

if [[ "${#}" -ne 3 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! "${1}" =~ ^[0-9.]+$ ]];then
        echo "Not a number"
        exit 4
fi


number="${1}"
prefix_symbol="${2}"
unit_symbol="${3}"

value="$(grep ",${prefix_symbol}," "prefix.csv" | cut -d ',' -f 3)"
#echo "${value}"

if [[ -z "${value}" ]];then
        echo "Prefix symbol not in prefix.csv"
        exit 2
fi

new_number="$(echo ${number}*${value} | bc)"
#echo "${new_number}"

if ! grep -q ",${unit_symbol}," "base.csv";then
        echo "Unit symbol not in base.csv"
        exit 3
fi

echo "${new_number} ${unit_symbol} ($(grep ",${unit_symbol}," "base.csv" | cut -d ',' -f 3), $(grep ",${unit_symbol}," "base.csv" | cut -d ',' -f 1))"
