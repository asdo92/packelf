#!/usr/bin/env sh
#set -o pipefail # bash extension
#set -e

# Pack elf binary and it's dependencies into standalone executable
# License: GPLv2.0

if [ -z "${1}" ] ; then
  echo "$0 <ELF_SRC_PATH> <PATH_TO_COPY_LIBRARIES>"
  exit 0
else
  if [ -z "${2}" ] ; then
    echo "$0 <ELF_SRC_PATH> <PATH_TO_COPY_LIBRARIES>"
    exit 0
  else
    libs="$(ldd "${1}" | grep -F '/' | sed -E 's|[^/]*/([^ ]+).*?|/\1|')"
    for library in ${libs} ; do
      cp -L ${library} ${2}
      echo "Copied ${library} to ${2}"
    done
  fi
fi
