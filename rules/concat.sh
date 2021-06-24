#/bin/sh -xe
OUT=$2
if [ -n "${2}" ]; then
    # exec 1 > "${2}" 
    set -e; for i in $1/*; do cat "$i"; echo '---'; done > "${2}"
else 
    set -e; for i in $1/*; do cat "$i"; echo '---'; done
fi
