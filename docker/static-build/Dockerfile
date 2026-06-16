FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PREFIX=/usr/local
ENV CFLAGS=-fPIC
ENV CXXFLAGS=-fPIC

RUN apt update && apt install -y --no-install-recommends \
    g++ make wget xz-utils pkg-config python3 meson ninja-build ca-certificates \
    autoconf automake libtool && \
    rm -rf /var/lib/apt/lists/*

# ---- zlib ----
ARG ZLIB_VER=1.2.13
RUN wget -q --timeout=30 --tries=3 https://github.com/madler/zlib/archive/refs/tags/v${ZLIB_VER}.tar.gz -O zlib-${ZLIB_VER}.tar.gz && \
    tar xf zlib-${ZLIB_VER}.tar.gz && cd zlib-${ZLIB_VER} && \
    CFLAGS="-fPIC -O3" ./configure --static --prefix=${PREFIX} && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf zlib-${ZLIB_VER}*

# ---- libffi ----
ARG LIBFFI_VER=3.4.4
RUN wget -q --timeout=30 --tries=3 https://github.com/libffi/libffi/releases/download/v${LIBFFI_VER}/libffi-${LIBFFI_VER}.tar.gz && \
    tar xf libffi-${LIBFFI_VER}.tar.gz && cd libffi-${LIBFFI_VER} && \
    ./configure --prefix=${PREFIX} --disable-shared --enable-static && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf libffi-${LIBFFI_VER}*

# ---- glib ----
ARG GLIB_VER=2.66.8
RUN wget -q --timeout=30 --tries=3 https://download.gnome.org/sources/glib/2.66/glib-${GLIB_VER}.tar.xz && \
    tar xf glib-${GLIB_VER}.tar.xz && cd glib-${GLIB_VER} && \
    meson setup _build --prefix=${PREFIX} --default-library=static \
        -Dselinux=disabled -Dlibmount=disabled --auto-features=disabled && \
    ninja -C _build && ninja -C _build install && \
    cd .. && rm -rf glib-${GLIB_VER}*

# ---- libsigc++ ----
ARG LIBSIGCPP_VER=2.10.8
RUN wget -q --timeout=30 --tries=3 https://download.gnome.org/sources/libsigc++/2.10/libsigc++-${LIBSIGCPP_VER}.tar.xz && \
    tar xf libsigc++-${LIBSIGCPP_VER}.tar.xz && cd libsigc++-${LIBSIGCPP_VER} && \
    autoreconf -i && \
    ./configure --prefix=${PREFIX} --disable-shared --enable-static && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf libsigc++-${LIBSIGCPP_VER}*

# ---- glibmm ----
ARG GLIBMM_VER=2.66.5
RUN wget -q --timeout=30 --tries=3 https://download.gnome.org/sources/glibmm/2.66/glibmm-${GLIBMM_VER}.tar.xz && \
    tar xf glibmm-${GLIBMM_VER}.tar.xz && cd glibmm-${GLIBMM_VER} && \
    PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig:${PREFIX}/lib64/pkgconfig \
    ./configure --prefix=${PREFIX} --disable-shared --enable-static && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf glibmm-${GLIBMM_VER}*

# ---- libxml2 ----
ARG LIBXML2_VER=2.9.14
RUN wget -q --timeout=30 --tries=3 https://download.gnome.org/sources/libxml2/2.9/libxml2-${LIBXML2_VER}.tar.xz && \
    tar xf libxml2-${LIBXML2_VER}.tar.xz && cd libxml2-${LIBXML2_VER} && \
    ./configure --prefix=${PREFIX} --disable-shared --enable-static \
        --without-python --without-lzma --without-http --without-ftp && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf libxml2-${LIBXML2_VER}*

# ---- libxml++ ----
ARG LIBXMLPP_VER=2.42.2
RUN wget -q --timeout=30 --tries=3 https://download.gnome.org/sources/libxml++/2.42/libxml++-${LIBXMLPP_VER}.tar.xz && \
    tar xf libxml++-${LIBXMLPP_VER}.tar.xz && cd libxml++-${LIBXMLPP_VER} && \
    PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig:${PREFIX}/lib64/pkgconfig \
    ./configure --prefix=${PREFIX} --disable-shared --enable-static && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf libxml++-${LIBXMLPP_VER}*

ENV PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig:${PREFIX}/lib64/pkgconfig

WORKDIR /build
