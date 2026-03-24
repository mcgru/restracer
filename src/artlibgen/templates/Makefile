CIFLAGS?=-O0 -g -ggdb -Wno-pointer-to-int-cast -Wno-int-conversion
CPFLAGS?=-O0 -g -ggdb -Wno-pointer-to-int-cast -Wno-int-conversion
SED:=$(shell type gsed > /dev/null 2> /dev/null && echo gsed || echo sed)

all: instrum-static-compiled instrum-dynamic-compiled preload-compiled

instrum-sources: instrum-sources-generics instrum-sources-specials
preload-sources: preload-sources-generics
#preload-sources: preload-sources-generics preload-sources-specials

instrum-sources-generics: templates
	@for i in posix*lint.xml posix*fork.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
mkdir -p "$$d"; \
../src/artlibgen "$$i" instrum "$$d/art.h" "$$d/art.c"; \
done

instrum-sources-specials: templates
	@for i in posix*special.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
mkdir -p "$$d"; \
../src/artlibgen "$$i" instrum "$$d/art.h" "$$d/art.c"; \
cp f04-api.h "$$d"; \
done

preload-sources-generics: templates
	@for i in posix*lint.xml posix*fork.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
mkdir -p "$$d"; \
../src/artlibgen "$$i" preload /dev/null "$$d/restracer_preload.c"; \
done

preload-sources-specials: templates
	@for i in posix*special.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
mkdir -p "$$d"; \
../src/artlibgen "$$i" preload /dev/null "$$d/restracer_preload.c"; \
done

instrum-static-compiled-generics: instrum-sources
	@for i in posix-gcc-mt-file-fork.xml posix-gcc-mt-file-lint.xml posix-gcc-mt-netw-lint.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
mkdir -p $$d/static; \
cc -c "$$d/art.c" -I "$$d" -o "$$d/static/art.o" ${CIFLAGS}; \
done

instrum-static-compiled-specials: instrum-sources
	@for i in posix*special.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
mkdir -p $$d/static; \
cc -c "$$d/art.c" -I "$$d" -I. -o "$$d/static/art.o"     ${CIFLAGS}; \
cc -c f04-api.c            -I. -o "$$d/static/f04-api.o" ${CIFLAGS}; \
done

instrum-dynamic-compiled-generics: instrum-sources
	@for i in posix-gcc-mt-file-fork.xml posix-gcc-mt-file-lint.xml posix-gcc-mt-netw-lint.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
mkdir -p $$d/dynamic; \
cc    "$$d/art.c" -I "$$d" -o "$$d/dynamic/restracer.so" -shared -fPIC -DPIC ${CIFLAGS}; \
done

instrum-dynamic-compiled-specials: instrum-sources
	@for i in posix*special.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
mkdir -p $$d/dynamic; \
cc -c "$$d/art.c" -I "$$d" -I. -o "$$d/dynamic/art.o"                -fPIC -DPIC ${CIFLAGS}; \
cc -c f04-api.c            -I. -o "$$d/dynamic/f04-api.o"            -fPIC -DPIC ${CIFLAGS}; \
cc            "$$d/dynamic/art.o" "$$d/dynamic/f04-api.o" -o \
                                  "$$d/dynamic/restracer.so" -shared -fPIC; \
done

preload-compiled-generics: preload-sources
	@for i in posix-gcc-mt-file-fork.xml posix-gcc-mt-file-lint.xml posix-gcc-mt-netw-lint.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
mkdir -p $$d/preload; \
cc    "$$d/restracer_preload.c" -o "$$d/preload/restracer_preload.so" -fPIC -DPIC ${CPFLAGS} -shared -ldl -rdynamic; \
done

preload-compiled-specials: preload-sources
	@for i in posix*special.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
mkdir -p $$d/preload; \
cc -c "$$d/restracer_preload.c" -o $$d/preload/restracer_preload.o -fPIC -DPIC ${CPFLAGS}; \
cc -c f04-api.c            -I.  -o $$d/preload/f04-api.o           -fPIC -DPIC ${CPFLAGS}; \
cc $$d/preload/restracer_preload.o $$d/preload/f04-api.o -o \
                                  "$$d/preload/restracer_preload.so" -fPIC -shared -ldl -rdynamic; \
done

instrum-static-compiled:   instrum-static-compiled-generics  instrum-static-compiled-specials
instrum-dynamic-compiled: instrum-dynamic-compiled-generics instrum-dynamic-compiled-specials
preload-compiled:                 preload-compiled-generics
#preload-compiled:                 preload-compiled-generics         preload-compiled-specials

templates: posix-gcc-mt-netw-lint.xml posix-gcc-mt-netw-special.xml \
posix-gcc-mt-file-fork.xml

clean:
	@for i in posix*.xml; do \
d=`echo "$$i" | ${SED} 's/.xml//g' -`; \
rm -rf "$$d"; \
done
	@rm -f tmp* posix-gcc-mt-netw-lint.xml posix-gcc-mt-netw-special.xml \
posix-gcc-mt-file-fork.xml

posix-gcc-mt-netw-lint.xml: posix-gcc-mt-file-lint.xml
	@${SED} -r 's/standalone/networked/g' posix-gcc-mt-file-lint.xml > $@
	@${SED} -i -r 's/remote_mode="false"/remote_mode="true"/g'         $@
	@${SED} -i -r 's/trace_target="tracefile.out"/trace_target="localhost:12345"/g' $@

posix-gcc-mt-netw-special.xml: posix-gcc-mt-file-special.xml
	@${SED} -r 's/standalone/networked/g' posix-gcc-mt-file-special.xml > $@
	@${SED} -i -r 's/remote_mode="false"/remote_mode="true"/g'            $@
	@${SED} -i -r 's/trace_target="tracefile.out"/trace_target="localhost:12345"/g' $@

posix-gcc-mt-file-fork.xml: posix-gcc-mt-file-lint.xml
	@${SED} -r 's/fork_enabled="false"/fork_enabled="true"/g' $<           > $@
	@${SED} -i -r 's/art_start_selfinit="true"/art_start_selfinit="false"/g' $@
