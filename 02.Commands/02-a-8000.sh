mkdir myetc
find /etc -type f -perm /222 -exec cp -r {} ~/myetc ';'
