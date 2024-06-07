temp_file=$(mktemp)
ps -eo comm | sort | uniq >> "${temp_file}"

comms=$(mktemp)

while read line;do
        echo "${line} 0" >> "${comms}"
done < <(cat "${temp_file}")

iterations=0

while true;do
        condition=0
        while read comm;do
                sum="$(ps -eo comm,rss | grep -E "^${comm} " | awk '{sum+=$2} END {print $2}')"
                if [[ "${sum}" -gt "65536" ]];then
                        condition=1
                        val="$(cat "${comms}" | grep -E "^${comm} " | cut -d ' ' -f 2)"
                        new_val=$((val+1))
                        sed -i -E "s/^${comm} ${val}$/${comm} ${new_val}/" "${comms}"
                fi
        done < <(cat "${comms}")
        if [[ "${condition}" -eq "1" ]];then
                break
        fi
        iterations=$((iterations+1))
        sleep 1
done

half=$((iterations))

while read -r comm count;then
        if [[ "${count}" -gt "${half}" ]];then
                echo "${comm}"
        fi
do

rm "${temp_file}"
rm "${comms}"
