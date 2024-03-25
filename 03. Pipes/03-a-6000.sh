cat ~/emp.data | awk ' END { print NR}'
cat ~/emp.data | awk ' NR == 3  { print $0}'
cat ~/emp.data | awk ' { print $NF}'
cat ~/emp.data | awk 'END { print $NF}'
cat ~/emp.data | awk 'NF > 4 { print $0}'
cat ~/emp.data | awk '$NF > 4 { print $0}'
cat ~/emp.data | awk 'BEGIN {sum=0} { sum +=NF } END {print sum}'

