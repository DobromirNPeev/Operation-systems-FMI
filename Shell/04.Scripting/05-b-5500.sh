#!/bin/bash

if [ $# -ne 0 ];then
        echo 'Invalid arguments'
        exit 1
fi

echo "<table>"
echo "  <tr>"
echo "          <th>Username</th>"
echo "          <th>Group</th>"
echo "          <th>Login shell</th>"
echo "          <th>Gecos</th>"
echo "  </tr>"

cat /etc/passwd | cut -d ':' -f 1,4,5,7 | while read line;do
        echo "  <tr>"
        a=$(echo "${line}" | cut -d ':' -f 1)
        b=$(echo "${line}" | cut -d ':' -f 2)
        c=$(echo "${line}" | cut -d ':' -f 4)
        d=$(echo "${line}" | cut -d ':' -f 3)
        echo "          <td>${a}</td>"
        echo "          <td>${b}</td>"
        echo "          <td>${c}</td>"
        echo "          <td>${d}</td>"
        echo "  </tr>"
done

echo "</table>"
