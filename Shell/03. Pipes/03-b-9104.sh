find ~/songs -type f | cut -d '/' -f 6 | sed -E 's/.*\((.*)\).*/\1/' |sort -n -k 2 -t ',' | uniq
