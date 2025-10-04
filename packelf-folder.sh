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
  echo "executable_dir=$program" >> $filename
  echo "tmp_parent=~/.cache" >> $filename
  echo 'if [ "$1" = "--packelf-extract" ] ; then' >> $filename
  echo '  mkdir -p packelf-files' >> $filename 
  echo "  echo \"Extracting to 'packelf-files'\"" >> $filename 
  echo "  sed '1,/^#__END__\$/d' \"\$0\" | tar \$compress_flag -x -C packelf-files" >> $filename
  echo "  exit 0" >> $filename 
  echo "fi" >> $filename 
  echo 'mkdir -p "$tmp_parent"' >> $filename
  echo 'unpack_dir="$tmp_parent/$executable_dir"' >> $filename
  echo 'mkdir -p $unpack_dir' >> $filename
  echo "sed '1,/^#__END__\$/d' \"\$0\" | tar \$compress_flag -x -C \"\$unpack_dir\"" >> $filename
  echo "chmod 777 -R \"\$unpack_dir\"/* 2> /dev/null" >> $filename
  echo '"$unpack_dir/$executable_run" "$@"' >> $filename
  echo 'active_process=$(ps -ef | grep "$unpack_dir/$executable_run" | grep -v grep)' >> $filename
  echo 'if [ -z $active_process ] ; then' >> $filename
  echo "  rm -rf \$unpack_dir" >> $filename
  echo 'fi' >> $filename
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
  echo "Creating package $2"
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
  echo "$0 <FOLDER> <FILENAME> <EXECUTABLE_RUN>"
  exit 0
}

if [ -z "$1" ] ; then
  help
else
  if [ -z "$2" ] ; then
    help
  else
    if [ -z "$3" ] ; then
      help
    else
      program="$(basename "$1")"
      pack "$1" "$2" "$3"
    fi
  fi
fi
