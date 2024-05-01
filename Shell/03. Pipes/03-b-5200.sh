cat /etc/passwd | grep -o '.' | grep -E '[^aа]' | sort | uniq | wc -l
