#!/bin/sh -e

if [ $# -eq 0 ]; then echo "Usage: $0 tag"; exit 0; fi

case `uname -s` in
    Linux)
        OS=linux;;
    FreeBSD)
        OS=freebsd;;
    SunOS)
        OS=nexenta;;
    *)
        OS=unknown;;
esac

restracer_dir=restracer-$1-$OS-`uname -m`
restracer_dir=`echo $restracer_dir | sed 's/i[3-6]86/x86/g'`
#restracer_dir=`echo $restracer_dir | sed 's/mips64/mipsel/g'`
cd src && scons -Q -j`nproc` OS=$OS STATIC=0 RELEASE=1 && cd .. && mkdir $restracer_dir

if [ ! $? -eq 0 ]; then echo "Build failure." exit 1; fi

cp src/artlibgen/src/artlibgen $restracer_dir &&
cp src/artrepgen/artrepgen $restracer_dir &&
strip $restracer_dir/* &&
cp src/artlibgen/templates/posix-gcc-mt-file-lint.xml $restracer_dir &&
cp regressions/features/003/main.c $restracer_dir/003.c &&
tar cf $restracer_dir.tar $restracer_dir &&
cp $restracer_dir.tar $restracer_dir.tar- &&
gzip -9 $restracer_dir.tar &&
#cp $restracer_dir.tar- $restracer_dir.tar &&
#bzip2 -9 $restracer_dir.tar &&
mv $restracer_dir.tar- $restracer_dir.tar &&
7z a -mx=9 $restracer_dir.7z $restracer_dir &&
rm $restracer_dir.tar && rm -rf $restracer_dir

if [ $OS = "linux" ]; then
    md5sum $restracer_dir.tar.* $restracer_dir.7z > $restracer_dir.CHECKSUM.md5; fi
if [ $OS = "nexenta" ]; then
    md5sum $restracer_dir.tar.* $restracer_dir.7z > $restracer_dir.CHECKSUM.md5; fi
if [ $OS = "freebsd" ]; then
    md5 -r $restracer_dir.tar.* $restracer_dir.7z > $restracer_dir.CHECKSUM.md5;
    sed 's/ /  /g' $restracer_dir.CHECKSUM.md5 > tmp;
    mv tmp $restracer_dir.CHECKSUM.md5; # make it suitable for gnu md5sum -c
fi
