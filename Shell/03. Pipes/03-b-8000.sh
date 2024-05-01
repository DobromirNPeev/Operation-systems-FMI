cat /srv/fmi-os/exercises/data/mypasswd.txt | grep -E '/home/SI' | cut -d ':' -f 1 | sed -E 's/[a-z]//g' | sort -n >si.txt
