cat /etc/passwd | nl | awk '$1 >= 28 && $1 <=46 {print $0}' | cut -d ':' -f 3 | sed -E 's/([0-9])/\1 /g' | awk '{print $NF}'
