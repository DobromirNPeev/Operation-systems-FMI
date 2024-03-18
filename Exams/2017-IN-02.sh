find . -size 0 -type f  -exec rm {} ';'

rm $(find ~ -type f -user $(whoami) -printf '%s %p\n' | sort -k 1 -rn | head -n 5 | cut -d ' ' -f 2)
