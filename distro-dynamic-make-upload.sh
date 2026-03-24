#!/bin/sh -e

TIMESTAMP=`date --iso-8601=minutes --utc | sed 's/[+:]/-/g;s/-00-00//g' -`
CURRENT_ENV_LIB_DIR=/usr/lib/x86_64-linux-gnu
OS=linux
DESTDIR=/opt/restracer
DESTNAME=restracer-$TIMESTAMP-$OS-amd64
DESTNAMELINK=restracer-current-$OS-amd64.tar.xz

make -j$(nproc) release
     rm *.tar*
     rm -f                      $DESTNAMELINK
     ln -s $DESTNAME.tar.xz     $DESTNAMELINK
     ln -s $DESTNAME.tar.xz.asc $DESTNAMELINK.asc
sudo rm -rf              $DESTDIR
sudo             DESTDIR=$DESTDIR/local make install
sudo strip               $DESTDIR/local/bin/artlibgen $DESTDIR/local/bin/artrepgen
sudo mkdir $DESTDIR/lib64/
sudo cp -L $CURRENT_ENV_LIB_DIR/libxml++-2.6.so.2 $CURRENT_ENV_LIB_DIR/libglibmm-2.4.so.1 \
$CURRENT_ENV_LIB_DIR/libgobject-2.0.so.0 $CURRENT_ENV_LIB_DIR/libglib-2.0.so.0 \
$CURRENT_ENV_LIB_DIR/libsigc-2.0.so.0 $CURRENT_ENV_LIB_DIR/libgmodule-2.0.so.0 \
$CURRENT_ENV_LIB_DIR/libffi.so.6 $CURRENT_ENV_LIB_DIR/libpcre.so.3 $DESTDIR/lib64/
tar cf   $DESTNAME.tar -C $DESTDIR .
xz -9    $DESTNAME.tar
gpg -abs $DESTNAME.tar.xz
echo "cd art/master
put $DESTNAME.tar.xz
put $DESTNAME.tar.xz.asc
delete  $DESTNAMELINK
delete  $DESTNAMELINK.asc
put     $DESTNAMELINK
put     $DESTNAMELINK.asc" | ftp -i skylark.tsu.ru
echo "Ignore error messages like 'Could not delete restracer-current-linux-amd64.tar.xz: No such file or directory' if you see it"
