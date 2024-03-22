cat /etc/passwd | cut -d ':' -f 5| egrep ' \<[а-яА-Я]{,7}\>' | xargs -I{} grep {} /etc/passwd
