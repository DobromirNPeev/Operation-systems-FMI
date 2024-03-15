cat /etc/passwd | cut -f 5,6 -d ':' | tr ',:SI' ' ' | tr -s ' '
