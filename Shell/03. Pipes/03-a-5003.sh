cat /etc/passwd | cut -d ':' -f 5 | tr ',SIKN' ' ' | egrep ' \<[а-яА-Я]{,7}\>'
