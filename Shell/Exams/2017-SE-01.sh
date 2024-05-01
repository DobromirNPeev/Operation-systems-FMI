find . -maxdepth 1 -type f -printf '%n %p\n' | sort -k 1 -rn | head -n 5 | cut -d ' ' -f 2
