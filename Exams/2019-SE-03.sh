find /home/velin -inum $(find /home/velin -printf '%C@ %i\n' 2>/dev/null | sort -n | tail -n 1 | cut -d ' ' -f 2) -printf '%d %p\n' 2>/dev/null
