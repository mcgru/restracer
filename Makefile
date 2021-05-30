DESTDIR?=/usr/local

# artlibgen, artrepgen uses CFLAGS
# instrumented restracer library uses CIFLAGS

# -Wno-deprecated-declarations prevents libxml++-2.6 warnings
debug:
	CFLAGS="-g -ggdb -Wall -Wextra -Werror -ansi -DART_DEBUG_INSERT_DEVEL_COMMENT \
-std=c++11 \
-Wno-deprecated-declarations \
-DART_DEBUG" \
CIFLAGS="-O0 -g -ggdb -Wno-pointer-to-int-cast -Wno-int-conversion" \
$(MAKE) all
#	CFLAGS="-Wall -Wextra -Werror -ansi -pedantic -std=c++0x \
#-DART_DEBUG_INSERT_DEVEL_COMMENT \
#-DART_DEBUG" make all

release:
	CFLAGS="-Wno-deprecated-declarations -O3 -fomit-frame-pointer" \
CIFLAGS="-O2 -Wno-pointer-to-int-cast -Wno-int-conversion" \
$(MAKE) all

all:
	$(MAKE) -C src/libs
	$(MAKE) -C src/artlibgen/src
	$(MAKE) -C src/artrepgen
	$(MAKE) -C src/artlibgen/templates

test: all
	$(MAKE) -C regressions/features

clean:
	$(MAKE) -C src/libs clean
	$(MAKE) -C src/artlibgen/src clean
	$(MAKE) -C src/artrepgen clean
	$(MAKE) -C regressions/features clean
	$(MAKE) -C src/artlibgen/templates clean

install:
#	src/artlibgen/src/artlibgen src/artlibgen/templates/posix-gcc-mt-file-lint.xml art.h art.c
#	src/artlibgen/src/artlibgen src/artlibgen/templates/posix-gcc-mt-file-fork.xml art_fork.h art_fork.c
#	$(CC) -c art.c art_fork.c -g -ggdb -Wno-pointer-to-int-cast
#	cp art.h art_fork.h $(DESTDIR)/include
#	mkdir -p $(DESTDIR)/lib/art
#	cp art.o art_fork.o $(DESTDIR)/lib/art
	cp src/artlibgen/src/artlibgen src/artrepgen/artrepgen src/utils/* $(DESTDIR)/bin
	mkdir -p                       $(DESTDIR)/lib/restracer
	cp -r src/artlibgen/templates  $(DESTDIR)/lib/restracer

deinstall: uninstall

uninstall:
	rm -f $(DESTDIR)/bin/artlibgen $(DESTDIR)/bin/artrepgen \
$(DESTDIR)/bin/rt-make $(DESTDIR)/bin/restracer-make \
$(DESTDIR)/bin/rt-gmake $(DESTDIR)/bin/restracer-gmake \
$(DESTDIR)/bin/restracer-gcc $(DESTDIR)/bin/restracer-g++ \
$(DESTDIR)/bin/restracer-cc $(DESTDIR)/bin/restracer-c++ $(DESTDIR)/bin/restracer-ld
#	rm -f $(DESTDIR)/include/art.h $(DESTDIR)/lib/art/art.o
#	rm -f $(DESTDIR)/include/art_fork.h $(DESTDIR)/lib/art/art_fork.o
	rm -rf $(DESTDIR)/lib/restracer
