grep -E --color '^Bulgaria,.*$' ~/population.csv | sort -t ',' -k 4 -rn | head -n 1 | awk -F ',' '{print $3}'
