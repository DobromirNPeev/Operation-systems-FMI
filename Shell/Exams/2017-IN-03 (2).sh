#!/bin/bash

newest_files="$(mktemp)"

while read home_dir;do
        find "${home_dir}" -type f -printf "%T@ %p ${home_dir}\n" 2>/dev/null | sort -k 1 -t ' ' -rn | head -n 1 >> "${newest_files}"
done < <(cat /etc/passwd |cut -d ':' -f 6)

cat "${newest_files}" | sort -k 1 -t ' ' -rn | head -n 1 | awk '{print $3}'

rm "${newest_files}"
