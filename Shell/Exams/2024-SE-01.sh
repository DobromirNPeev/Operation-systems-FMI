file=""
replaces=$(mktemp)

for arg in "${@}";do
        if [[ -f "${arg}" ]];then
                if [[ -n "${file}" ]];then
                        echo "Only one file allowed"
                        rm "${replaces}"
                        exit 0
                fi
                if [[ "${arg}" =~ ^-.* ]];then
                        echo "Cannot begin with -"
                        exit 2
                fi
                file="${arg}"
        else
                if [[ ! "${arg}" =~ ^-R[a-zA-Z0-9]*=[a-zA-Z0-9]* ]];then
                        echo "Invalid replacement"
                        rm "${replaces}"
                        exit 1
                fi
                echo "${arg}" >> "${replaces}"
        fi
done

changed=$(mktemp)

while read replace;do
        lhs="$(echo "${replace}" | cut -d "=" -f 1 | tail -c +3)"
        rhs="$(echo "${replace}" | cut -d "=" -f 2)"
        rhs+="$(pwgen -1 | head -n 1)"
        echo "${rhs}" >> "${changed}"
        sed -i -E "s/\<${lhs}\>/${rhs}/" "${file}"
done < <(cat "${replaces}")

while read line;do
        pwgen_rem="$(echo "${line}" | head -c -9)"
        sed -i -E "s/\<$line\>/${pwgen_rem}/" "${file}"
done < <(cat "${changed}")

rm "${replaces}"
rm "${changed}"
