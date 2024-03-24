find /usr -type f | grep -E '^.*\.sh$' | xargs -I{} head  -n 1 "{}" |grep -E '^#!' | sort | uniq -c | sort -k 1 -rn -t ' ' | head -n 1 | sed -E 's/ *[0-9]+ //'
