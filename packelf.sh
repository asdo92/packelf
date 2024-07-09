#!/usr/bin/env sh
#set -o pipefail # bash extension
#set -e

# Pack elf binary and it's dependencies into standalone executable
# License: GPLv2.0

# These vars will be modified automatically with sed
compress_flag=-z

unpack() {
  filename=$1
  echo "#!/usr/bin/env sh" > $filename
  echo "#set -o pipefail # bash extension" >> $filename
  echo "#set -e" >> $filename
  echo "" >> $filename
  echo "compress_flag=$compress_flag" >> $filename
  echo "executable_run=$2" >> $filename
  echo "tmp_parent=/tmp" >> $filename
  echo 'if [ "$1" = "--packelf-extract" ] ; then' >> $filename
  echo '  mkdir -p packelf-files' >> $filename 
  echo "  echo \"Extracting to 'packelf-files'\"" >> $filename 
  echo "  sed '1,/^#__END__\$/d' \"\$0\" | tar \$compress_flag -x -C packelf-files" >> $filename
  echo "  exit 0" >> $filename 
  echo "fi" >> $filename 
  echo 'mkdir -p "$tmp_parent"' >> $filename
  echo 'unpack_dir=$(mktemp -d -p "$tmp_parent" || echo "$tmp_parent")' >> $filename
  echo "sed '1,/^#__END__\$/d' \"\$0\" | tar \$compress_flag -x -C \"\$unpack_dir\"" >> $filename
  echo "chmod 777 -R \"\$unpack_dir\"/* 2> /dev/null" >> $filename
  echo '"$unpack_dir/$executable_run" "$@"' >> $filename
  echo "rm -rf \$unpack_dir" >> $filename
  echo "exit 0" >> $filename
  echo "#__END__" >> $filename
}

pack() {
  folder=$1
  filename=$2
  executable_run=$3
  temp_file=$(mktemp)
  current_dir=$(pwd)
  if [ ! -d "$folder" ] ; then
    echo "Folder $folder does not exist"
    exit 0
  fi 
  #echo "Creating executable $2"
  unpack $filename $executable_run
  cd $folder
  chmod 777 -R * 2> /dev/null
  tar $compress_flag -c -f $temp_file *
  cd $current_dir
  cat $temp_file >> $filename
  rm -rf $temp_file
  echo "Created successfully"
}

help() {
  echo "$0 <ELF_SRC_PATH> <DST_PATH>"
  exit 0
}

if [ ! -z "$1" ] ; then
  if [ ! -f "$1" ] ; then
    echo "$0: File $1 does not exist"
    exit 1
  else
    libs="$(ldd "$1" | grep -F '/' | sed -E 's|[^/]*/([^ ]+).*?|/\1|')"
    ld_so="$(echo "$libs" | grep -F '/ld-linux-' || echo "$libs" | grep -F '/ld-musl-' || echo "$libs" | grep -F '/ld.so')"
    ld_so="$(basename "$ld_so")"
    program="$(basename "$1")"
    if [ -z "$libs" ] ; then
      echo "$0: Not a dynamic executable"
      exit 1
    fi
  fi
else
  help
  exit 0
fi

if [ -z "$2" ] ; then
  help
else
  temp_dir=$(mktemp -d)
  echo "Creating static binary ${2} from ${1}"
  echo "Linking libraries"
  cp -L ${1} ${temp_dir}/ 
  for libraries in ${libs} ; do
    cp -L ${libraries} ${temp_dir}/
  done
  echo "#!/usr/bin/env sh" > ${temp_dir}/AppRun
  echo "" >> ${temp_dir}/AppRun
  echo "\$(dirname \$0)/${ld_so} --library-path \$(dirname \$0) \$(dirname \$0)/${program} \"\$@\"" >> ${temp_dir}/AppRun
  chmod 777 -R "$temp_dir"
  pack "$temp_dir" "$2" AppRun
fi

