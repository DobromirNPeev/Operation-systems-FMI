find / -maxdepth 3 -type d -exec ls -d '{}' ';' 2>&1 | grep 'Permission denied'
