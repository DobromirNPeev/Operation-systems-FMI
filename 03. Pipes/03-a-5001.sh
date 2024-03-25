cat /etc/passwd | grep -E -v '^.*:/bin/bash$' | wc -l
