find /usr/bin -type f -exec file '{}' ';' | grep -E 'ASCII text' | wc -l
