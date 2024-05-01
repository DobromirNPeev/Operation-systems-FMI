cat /etc/services | grep -i -o -E '[a-z]+' |sort | uniq -c |sed 's/ *//' | sort -rn -k 1 -t ' '  | head
