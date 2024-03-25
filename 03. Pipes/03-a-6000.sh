cat ~/emp.data | awk ' END { print NR}'
cat ~/emp.data | awk ' NR == 3  { print $0}'

