#!/bin/bash
set -e

# Force pkg-config to always use --static (picks up .a libs, not .so)
mkdir -p /tmp/pkgwrap
cat > /tmp/pkgwrap/pkg-config << 'WRAPPER'
#!/bin/bash
exec /usr/bin/pkg-config --static "$@"
WRAPPER
chmod +x /tmp/pkgwrap/pkg-config
export PATH=/tmp/pkgwrap:$PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig

# Build all internal libs statically, then the main tools
make -C src/libs clean
make -C src/libs

make -C src/artlibgen/src clean
make -C src/artlibgen/src \
    LDFLAGS="-static -L../../libs/libtplreader -L../../libs/liblinefetch \
-ltplreader -llinefetch $(pkg-config --static --libs libxml++-2.6)"

make -C src/artrepgen clean
make -C src/artrepgen \
    LDFLAGS="-static -L../libs/libtplreader -L../libs/liblinefetch \
-ltplreader -llinefetch $(pkg-config --static --libs libxml++-2.6)"

make -C src/artlibgen/templates

echo "=== Static build complete ==="
file src/artlibgen/src/artlibgen src/artrepgen/artrepgen
