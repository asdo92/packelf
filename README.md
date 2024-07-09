`packelf` was based on then [oufm](https://github.com/oufm/packelf) script, but is simpler and has extra tools. It is used to pack a ELF program and its dependent libraries into a single executable file.


## Usage packelf:

```
Usage: ./packelf.sh <ELF_SRC_PATH> <DST_PATH_FILENAME>
```

Example:

```
# ./packelf.sh /usr/bin/mpv mpv-x86_64.AppRun
```

Note: Every time the packed program is executed, an internal unpacking operation is performed automatically, which results in a slower startup of the program.

## Extract without running:

You can extract the files of a created package without executing it with the following command:

```                                                                                                                                                                                                                  
# ./<package> --packelf-extract                                                                                                                                                                        
```  

## Usage Extra Tools:

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
* ldd (only needed for packing, not needed for executing or unpacking)

