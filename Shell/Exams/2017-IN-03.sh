cut -d ':' -f 1,5 /etc/passwd | grep -E ',I$' | cut -d ',' -f 1 | grep 'а$' | cut -c 3-4 | sort -rn | uniq -c | head -n 1
