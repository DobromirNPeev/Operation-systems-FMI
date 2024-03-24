grep '^.*1969.*$' ~/population.csv | awk -F ',' '{print $NF}' | sort -rn | head -n 42 | tail -n 1 | xargs -I{} grep {} ~/population.csv
