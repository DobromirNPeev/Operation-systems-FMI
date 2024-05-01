find /usr/include  -type f | grep -E --color '^.*\.(c|h)$' | wc -l
find /usr/include -maxdepth 1 -type f | grep -E --color '^.*\.(c|h)$' | xargs -I{} cat {} | wc -l
