grep $(whoami) /etc/passwd
grep -B 2 $(whoami) /etc/passwd
grep -B 2 -A 3 $(whoami) /etc/passwd
grep -B 2 $(whoami) /etc/passwd | head -n 1
