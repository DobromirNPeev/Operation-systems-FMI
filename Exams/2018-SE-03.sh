cat /etc/passwd | sed 's/^.//' | sort -k 1 -t ':' -n | cut -d ':' -f 5,6 | egrep '^.*,,,,SI.*$'
