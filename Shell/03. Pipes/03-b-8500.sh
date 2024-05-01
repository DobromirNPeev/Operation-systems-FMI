cat /etc/group | cut -d ':' -f 1 | awk -v "my_group=$(groups)" '$1 == my_group {print "Hello, "$1" - I am here !" } $1 != my_group {print "Hello, "$1 }'
