find . -printf '%p:%M\n' | awk -F ':' -v "perms=$(find /etc -type f -printf '%s %p %M\n' 2>/dev/null| sort -k 1 -t ' ' -n | tail -n 1 | cut -d ' ' -f 3)" '$2 == perms {print $1}'
