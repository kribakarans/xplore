# GNU Makefile

all:
	cc -g3 src/main.c src/html.c src/tree.c -o cgi-bin/xplore.cgi -lkstat

clean:
	rm -f src/*.o cgi-bin/xplore.cgi
