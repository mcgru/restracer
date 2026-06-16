DESTDIR?=/usr/local

# artlibgen, artrepgen uses           CXXFLAGS
# src/utils/* uses                    CFLAGS
# instrumented restracer library uses CIFLAGS
# preload      restracer library uses CPFLAGS

# -Wno-deprecated-declarations prevents libxml++-2.6 warnings
debug:
	CXXFLAGS="-pipe -g -ggdb -Wall -Wextra -Werror -ansi -DART_DEBUG_INSERT_DEVEL_COMMENT \
-std=c++11 \
-Wno-deprecated-declarations \
-DART_DEBUG" \
CFLAGS="-pipe -g -ggdb -Wall -Wextra -Werror -ansi -DART_DEBUG_INSERT_DEVEL_COMMENT \
-Wno-deprecated-declarations \
-DART_DEBUG" \
CIFLAGS="-pipe -O0 -g -ggdb -Wno-pointer-to-int-cast -Wno-int-conversion" \
CPFLAGS="-pipe -O0 -g -ggdb -Wno-pointer-to-int-cast -Wno-int-conversion" \
$(MAKE) all
#	CXXFLAGS="-Wall -Wextra -Werror -ansi -pedantic -std=c++0x \
#-DART_DEBUG_INSERT_DEVEL_COMMENT \
#-DART_DEBUG" make all

release:
	CFLAGS="-pipe -Wno-deprecated-declarations -O3 -fomit-frame-pointer" \
CXXFLAGS="-pipe -Wno-deprecated-declarations -O3 -fomit-frame-pointer" \
CIFLAGS="-pipe -O2 -Wno-pointer-to-int-cast -Wno-int-conversion" \
CPFLAGS="-pipe -O1 -Wno-pointer-to-int-cast -Wno-int-conversion" \
$(MAKE) all

all:
	$(MAKE) -C src/libs
	$(MAKE) -C src/artlibgen/src
#	$(MAKE) -C src/utils/restracer_fullpather   # attic
#	$(MAKE) -C src/utils/restracer_preload      # sample
	$(MAKE) -C src/artrepgen
	$(MAKE) -C src/artlibgen/templates

test: all
	$(MAKE) -C regressions/features

clean:
	$(MAKE) -C src/libs             clean
	$(MAKE) -C src/artlibgen/src    clean
#	$(MAKE) -C src/utils/restracer_fullpather   clean   # attic
#	$(MAKE) -C src/utils/restracer_preload      clean   # sample
	$(MAKE) -C src/artrepgen            clean
	$(MAKE) -C regressions/features     clean
	$(MAKE) -C src/artlibgen/templates  clean

install:
	mkdir -p                       $(DESTDIR)/bin
	cp src/artlibgen/src/artlibgen src/artrepgen/artrepgen \
src/utils/rt-make src/utils/restracer-make \
src/utils/rt-gmake src/utils/restracer-gmake \
src/utils/restracer-gcc src/utils/restracer-g++ \
src/utils/restracer-cc src/utils/restracer-c++ src/utils/restracer-ld \
src/utils/restracer $(DESTDIR)/bin
	mkdir -p                       $(DESTDIR)/lib/restracer
	cp -r src/artlibgen/templates  $(DESTDIR)/lib/restracer
#	$(MAKE) -C src/utils/restracer_fullpather   install # attic
#	$(MAKE) -C src/utils/restracer_preload      install # sample

deb:
	@command -v dpkg-buildpackage >/dev/null 2>&1 || { echo "dpkg-buildpackage not found. Please run: make deps-debian"; exit 1; }

static:
	@mkdir -p distr-specific/static
	docker build -t restracer-static -f docker/static-build/Dockerfile docker/static-build
	docker run --rm -v "$(CURDIR)":/build -w /build restracer-static bash docker/static-build/build.sh
	rm -f src/artlibgen/templates/core
	cp src/artlibgen/src/artlibgen src/artrepgen/artrepgen \
		src/utils/rt-make src/utils/restracer-make \
		src/utils/rt-gmake src/utils/restracer-gmake \
		src/utils/restracer-gcc src/utils/restracer-g++ \
		src/utils/restracer-cc src/utils/restracer-c++ src/utils/restracer-ld \
		src/utils/restracer distr-specific/static/
	cp -r src/artlibgen/templates distr-specific/static/

static-deb: static
	@command -v dpkg-buildpackage >/dev/null 2>&1 || { echo "dpkg-buildpackage not found. Please run: make deps-debian"; exit 1; }
	cp -r distr-specific/debian distr-specific/debian.build
	sed -i '/libxml++2.6-2v5/d' distr-specific/debian.build/control
	mkdir -p distr-specific/debian.build/restracer/usr/bin distr-specific/debian.build/restracer/usr/lib/restracer
	cp distr-specific/static/artlibgen distr-specific/static/artrepgen \
		distr-specific/static/rt-make distr-specific/static/restracer-make \
		distr-specific/static/rt-gmake distr-specific/static/restracer-gmake \
		distr-specific/static/restracer-gcc distr-specific/static/restracer-g++ \
		distr-specific/static/restracer-cc distr-specific/static/restracer-c++ \
		distr-specific/static/restracer-ld distr-specific/static/restracer \
		distr-specific/debian.build/restracer/usr/bin/
	cp -r distr-specific/static/templates distr-specific/debian.build/restracer/usr/lib/restracer/
	ln -sf distr-specific/debian.build debian
	dpkg-buildpackage -us -uc -b; \
	ret=$$?; \
	mv -f ../restracer_*.deb distr-specific/debian/ 2>/dev/null; \
	rm -rf distr-specific/debian.build debian; \
	exit $$ret

static-rpm: static
	@command -v rpmbuild >/dev/null 2>&1 || { echo "rpmbuild not found. Please run: make deps-redhat"; exit 1; }
	mkdir -p distr-specific/redhat/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	cp distr-specific/static/* distr-specific/redhat/rpmbuild/SOURCES/
	cp -r distr-specific/static/templates distr-specific/redhat/rpmbuild/SOURCES/
	cp distr-specific/redhat/restracer.spec distr-specific/redhat/rpmbuild/SPECS/
	rpmbuild -bb --define "_topdir $(CURDIR)/distr-specific/redhat/rpmbuild" \
		distr-specific/redhat/rpmbuild/SPECS/restracer.spec
	mv distr-specific/redhat/rpmbuild/RPMS/*/*.rpm distr-specific/redhat/ 2>/dev/null || true
	rm -rf distr-specific/redhat/rpmbuild

deps-debian:
	sudo apt-get install -y build-essential libxml++2.6-dev dpkg-dev debhelper

deps-redhat:
	sudo dnf install -y make libxml++-devel gcc-c++ findutils diffutils psmisc rpm-build

deps-gentoo:
	sudo emerge dev-cpp/libxmlpp dev-util/pkgconfig

deps-arch:
	sudo pacman -S --noconfirm make gcc libxml++

deps-freebsd:
	sudo pkg install -y libxml++ gmake gsed pkgconf

deps-alt:
	sudo apt-get install -y make gcc-c++ libxml++2-devel

deinstall: uninstall

uninstall:
	rm -f $(DESTDIR)/bin/artlibgen $(DESTDIR)/bin/artrepgen \
$(DESTDIR)/bin/rt-make $(DESTDIR)/bin/restracer-make \
$(DESTDIR)/bin/rt-gmake $(DESTDIR)/bin/restracer-gmake \
$(DESTDIR)/bin/restracer-gcc $(DESTDIR)/bin/restracer-g++ \
$(DESTDIR)/bin/restracer-cc $(DESTDIR)/bin/restracer-c++ $(DESTDIR)/bin/restracer-ld \
$(DESTDIR)/bin/restracer
	rm -rf $(DESTDIR)/lib/restracer
#	$(MAKE) -C src/utils/restracer_fullpather   uninstall # attic
#	$(MAKE) -C src/utils/restracer_preload      uninstall # sample
