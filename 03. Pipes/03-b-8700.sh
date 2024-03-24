cat /etc/passwd | cut -d ':' -f 4 | sort -n | uniq -c |sed 's/ *//' | sort -k 1 -t ' ' -rn | sed 's/[0-9]* //' | head -n 5

cat /etc/passwd | cut -d ':' -f4 | sort -n | uniq -c | sort -nr | head -n 5 | awk '{print $2}' | xargs -I{} grep ':{}:' /etc/group | cut -d ':' -f 1
