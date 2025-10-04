##############################################
# Installing packelf tools (for Unix/Linux)  #
##############################################

PREFIX=/usr

install:
	cp -rf packelf.sh $(PREFIX)/bin/packelf
	chmod +x $(PREFIX)/bin/packelf
	cp -rf packelf-folder.sh $(PREFIX)/bin/packelf-folder
	chmod +x $(PREFIX)/bin/packelf-folder
	cp -rf packelf-copylibs.sh $(PREFIX)/bin/packelf-copylibs
	chmod +x $(PREFIX)/bin/packelf-copylibs
	cp -rf packelf.1 $(PREFIX)/share/man/man1/
	
uninstall:
	rm -rf $(PREFIX)/bin/packelf
	rm -rf $(PREFIX)/bin/packelf-folder
	rm -rf $(PREFIX)/bin/packelf-copylibs
	rm -rf $(PREFIX)/share/man/man1/packelf.1
