#!/bin/bash

if [[ "${#}" -ne 2 ]];then
        echo "Invalid number of arguments"
        exit 1
fi

if [[ ! -d  "${1}" || ! -d "${2}" ]];then
        echo "Not a dir"
        exit 2
fi

container="${1}"
package="${2}"
archive_package="$(mktemp)"
tar -cf - "${package}/tree" | xz -c - > "${archive_package}.tar.xz"
sha256=$(tar -xf "${archive_package}.tar.xz" | sha256sum | cut -d ' ' -f 1)
echo "${sha256}"
mv "${archive_package}.tar.xz" "${sha256}.tar.xz"

version="$(cat "${package}/version")"

if grep -q "${package}-${version}" "${container}/db";then
        archive="$(grep "${package}-${version}" "${container}/db" | cut -d ' ' -f 2)"
        rm "${container}/packages/${archive}.tar.xz"
        mv "${sha256}.tar.xz" "${container}/packages"
        sed -i -E "s/(${package}-${version}) (.*)/\1 ${sha256}/" "${container}/db"
else
        mv "${sha256}.tar.xz" "${container}/packages"
        echo "${package}-${version} ${sha256}" >> "${container}/db"
        sorted="$(mktemp)"
        cat "${container}/db" > "${sorted}"
        cat "${sorted}" | sort -k 1 -t ' ' > "${container}/db"
fi

