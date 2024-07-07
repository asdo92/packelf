`packelf` was inspired by [the idea of Klaus D](https://askubuntu.com/a/546305). It is used to pack a ELF program and its dependent libraries into a single executable file.


## Usage (packelf):

```
Usage: ./packelf.sh <ELF_SRC_PATH> <DST_PATH> [ADDITIONAL_LIBS]
```

First, pack a ELF program. For example, you can pack `ls` like this:

```
# ./packelf.sh /bin/ls /root/ls
tar: Removing leading `/' from member names
'/bin/ls' was packed to '/root/ls'
Just run '/root/ls ARGS...' to execute the command.
Or run 'PACKELF_UNPACK_DIR=xxx /root/ls' to unpack it only.
```

You can execute the packed program directly:

```
# /root/ls -lh /root/ls 
-rwxr-xr-x 1 root root 1.3M May 21 08:35 /root/ls
```

However, every time the packed program is executed, an internal unpacking operation is performed automatically, which results in a slower startup of the program.

## USAGE EXTRA TOOLS:

```                                                                                                                                                                                                                  
Usage: ./packelf-copylibs.sh <ELF_SRC_PATH> <PATH_TO_COPY_LIBRARIES>
```

```                                                                                                                                                                                                                  
Usage: ./packelf-folder.sh <FOLDER> <FILENAME> <EXECUTABLE_RUN>
```

## Dependencies
* sh
* tar
* sed
* grep
* chmod
* readlink
* ldd (only needed for packing, not needed for executing or unpacking)

Note: If your tar doesn't support gzip, '-n' is needed when you pack a program.
