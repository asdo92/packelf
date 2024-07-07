#!/usr/bin/env sh

if [ -z "${1}" ] ; then
  echo "$0 <path-elf> <path-to-copy-libraries>"
  exit 0
else
  if [ -z "${2}" ] ; then
    echo "$0 <path-elf> <path-to-copy-libraries>"
    exit 0
  else
    libs="$(ldd "${1}" | grep -F '/' | sed -E 's|[^/]*/([^ ]+).*?|/\1|')"
    for library in ${libs} ; do
      cp -L ${library} ${2}
      echo "Copied ${library} to ${2}"
    done
  fi
fi
