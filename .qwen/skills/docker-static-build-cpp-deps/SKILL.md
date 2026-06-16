---
name: docker-static-build-cpp-deps
description: Building C++ project with all transitive deps from source as static .a libs in a Docker container, using a pkg-config wrapper to force --static
source: auto-skill
extracted_at: '2026-06-16T05:29:28.381Z'
---

# Docker-based static build for C++ projects with deep library deps

## The problem

A C++ project depends on a library (e.g. `libxml++-2.6`) that depends on `glibmm`, `libsigc++`, `glib`, `libxml2`, `zlib`, `libffi`. Most distros don't ship static `.a` versions of C++ libraries. You want a fully static binary without installing build deps on the host.

## Solution: Docker image that builds the entire dep chain from source as static libs

### 1. Dependency tree (map it first)

Figure out the full transitive closure. For `libxml++-2.6`:
```
zlib → libxml2 → glib → libsigc++ → glibmm → libxml++
                    ↑ libffi
```

### 2. Dockerfile structure

Use a slim base, install only build tools (`g++ make wget meson ninja pkg-config`). Build each dep in dependency order, always with `--disable-shared --enable-static` (or meson `--default-library=static`). Install to `/usr/local`:

```dockerfile
FROM debian:12-slim
ENV PREFIX=/usr/local
RUN apt update && apt install -y --no-install-recommends g++ make wget xz-utils pkg-config python3 meson ninja-build

# zlib (autotools-style)
RUN ./configure --static --prefix=${PREFIX} && make -j$(nproc) && make install

# glib (meson)
RUN meson setup _build --prefix=${PREFIX} --default-library=static -Dtests=false && \
    ninja -C _build && ninja -C _build install

# C++ libs: need PKG_CONFIG_PATH to find previously-built deps
RUN PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig ./configure --prefix=${PREFIX} --disable-shared --enable-static

ENV PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig:${PREFIX}/lib64/pkgconfig
```

Key: set `PKG_CONFIG_PATH` so each step finds the static `.pc` files of previous steps.

### 3. The pkg-config wrapper trick

Makefiles using `$(shell pkg-config --libs ...)` call `pkg-config` directly, not respecting env vars. Solution: a wrapper script that adds `--static`, placed first in `PATH`:

```bash
mkdir -p /tmp/pkgwrap
cat > /tmp/pkgwrap/pkg-config << 'WRAPPER'
#!/bin/bash
exec /usr/bin/pkg-config --static "$@"
WRAPPER
chmod +x /tmp/pkgwrap/pkg-config
export PATH=/tmp/pkgwrap:$PATH
```

Now all `pkg-config --libs libxml++-2.6` calls return static library flags.

### 4. Fix sub-Makefiles: `LDFLAGS=` → `LDFLAGS+=`

If sub-Makefiles use `LDFLAGS=-L... -l...` (assignment), passing `LDFLAGS=-static` from the top wipes the lib paths. Change to `LDFLAGS+=` everywhere so flags accumulate.

### 5. Build invocation

```bash
make -C src/artlibgen/src \
    CXXFLAGS="-pipe -O3 -fomit-frame-pointer" \
    LDFLAGS="-static"
```

Verify with `file` and `ldd`:
```bash
$ file artlibgen
artlibgen: ELF 64-bit LSB executable, statically linked
$ ldd artlibgen
not a dynamic executable
```

## Version compatibility notes

When choosing source versions, stay within the same major/generation. Example combo that works:
- zlib 1.2.13, libffi 3.4.4, glib 2.66.8, libsigc++ 2.10.8, glibmm 2.66.5, libxml2 2.9.14, libxml++ 2.42.2

If glib is too new, glibmm may fail to configure. Stick to the same minor generation across glib/glibmm.
