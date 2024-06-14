#!/bin/bash

if [[ "${#}" -ne 1 ]];then
        echo "invalid number of args"
        exit 1
fi

fuga="${1}"

find "${fuga}/cfg" -type f -name "*.cfg" | while read cfg_file;do
        output="$(${fuga}/validate.sh ${cfg_file})"
        if [[ -z "${output}" ]];then
                continue
        fi
        bs_name="$(basename "${cfg_file}")"
        echo "${bs_name}:${output}" >&2
done

if [[ -f "${fuga}/foo.conf" ]];then
        rm "${fuga}/foo.conf"
else
        touch "${fuga}/foo.conf"
fi

find "${fuga}/cfg" -type f -name "*.cfg" | while read cfg_file;do
        output="$(${fuga}/validate.sh ${cfg_file})"
        if [[ -z "${output}" ]];then
                cat "${cfg_file}" >> "${fuga}/foo.conf"
        fi
done

find "${fuga}/cfg" -type f -name "*.cfg" | while read cfg_file;do
        ${fuga}/validate.sh ${cfg_file} > /dev/null
        if [[ "${?}" -eq 0 ]];then
                user="$(basename  "${cfg_file}" .cfg)"
                if ! cat "${fuga}/foo.pwd" | grep -q -E "^${user}:.*$";then
                        pass="$(pwgen)"
                        hash="$(mkpasswd "${pass}")"
                        echo "${user}:${pass}"
                        echo "${user}:${hash}" >> "${fuga}/foo.pwd"
                fi
        fi
done
