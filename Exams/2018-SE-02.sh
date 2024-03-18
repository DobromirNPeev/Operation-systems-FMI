find ~/pesho -type f -printf '%i %n  %t\n' | grep -v ' 1 ' | sort -rn -k 3 | cut -d ' ' -f 1 | head -n 1
