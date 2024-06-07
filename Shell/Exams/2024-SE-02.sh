local_users=$(mktemp)

cat /etc/passwd | awk -F : '$3>=1000 { print $0}' | cut -d ':' -f 5 > "${local_users}"

while read username;do
        if ! occ user:list | grep -F "${username}";then
                occ user:add "${username}"
        else
                if occ user:info "${username}" | head -n 4 | tail -n 1 | grep -F "disable";then
                        occ user:enable "${username}"
                fi
        fi
done < <(cat "${local_users}")

while read prevcloud_user;do
        if ! cat "${local_users}" | grep -F "${prevcloud_user}";then
                if occ user:info "${prevcloud_user}" | head -n 4 | tail -n 1 | grep -F "true";then
                        occ user:disable "${username}"
                fi
        fi
done < <"(occ user:list}"

rm "${local_users}"
