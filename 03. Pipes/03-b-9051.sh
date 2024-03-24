grep -E --color '^.*,.*,2008,.*$' ~/population.csv  | awk -F ',' 'BEGIN { population =0 } {population +=$NF} END {print population}'
grep -E --color '^.*,.*,2016,.*$' ~/population.csv  | awk -F ',' 'BEGIN { population =0 } {population +=$NF} END {print population}'
