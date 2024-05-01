#!/bin/bash

if [[ ! "${1}" =~ ^[0-9]+$ ]];then
        echo "Not a number"
        exit 1
fi



number="${1}"
shift
command="${1}"
shift
for arg in "${@}";do
        command+=" ${arg}"
done

count=0
sum=0
while true;do
        timenow="$(date +"%s.%N" | grep -E -o '.*\...')"
        #echo "${timenow}"
        ${command}
        newtime="$(date +"%s.%N" | grep -E -o '.*\...')"
        diff="$(echo "scale=2; ${newtime}-${timenow}" | bc)"
        count=$((count+1))
        #echo "${sum}"
        sum="$(echo "scale=2; ${sum}+${diff}" | bc)"
        if (( $(echo "${sum}>${number}" | bc) ));then
                break
        fi
done

echo "Ran the command '${command}' ${count} times for ${sum}."
echo "Average runtime: $(echo "scale=2;${sum}/${count}" | bc) second."

