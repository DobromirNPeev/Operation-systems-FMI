cat /etc/passwd | cut -d ':' -f 5| egrep ' \<[а-яА-Я]{,7}\>' | xargs -I{} grep {} /etc/passwd

cat /etc/passwd | cut -d ':' -f 5| cut -d ',' -f 1 | grep -E ' [а-яА-я]{,7}$' > 5003.out
cat /etc/passwd | grep -f 5003.out

