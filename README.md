# Resource Tracer project
## Description
- A resource tracing, debugging and profiling tool
- [Restracer@github](https://github.com/larkvirtual/restracer)

Crossplatform method to trace software errors in runtime during resource manipulation is shown. A scheme for describing abstract resources and their functions in XML is presented. Due to separation it's possible to describe vast classes of resources without changing the analyzer core. Detected errors often have an influence on security, safety, robustness and resource optimal usage.

### Supported programming languages

Language | Status
---------|-------------------
C        | :white_check_mark:
C++      | :construction:
others   | possible

### Supported multitasking
Method         | Status
---------------|-------------------
POSIX threads  | :white_check_mark:
fork()         | :construction:
Windows threads| possible

### Supported execution models

execution model | Status
----------------|-------------------
Userspace       | :white_check_mark:
Kernel          | possible
Embedded        | possible

### Supported traced application OS environment
OS            | Status
--------------|-------------------
`GNU/Linux`   | :white_check_mark:
`FreeBSD`     | :white_check_mark:
`Solaris`     | possible
`MacOS`       | possible
`Windows`     | possible

### Supported traced application hardware
Arch                 | Status
---------------------|-------------------
`IA32` (`x86`/`x64`) | :white_check_mark:
`IA64`               | possible
other 64bit          | possible
other 32bit          | possible
other 16bit          | possible
other 8bit           | possible

### Supported build tools
- `GNU Make`
- `BSD Make`

Environtment | BuildTool `GNU Make` | BuildTool `BSD Make` |
-------------|----------------------|----------------------|
`GNU/Linux`  | `make`               |                      |
`FreeBSD`    | `gmake`              | `make`               |


## Install
### Gentoo (stage3 or stage3+)
- `sudo sh -c 'echo 92.63.64.5 skylark.tsu.ru >> /etc/hosts'`
- `export GPG_KEY=B0414424; export DISTRO_TARBALL_NAME=restracer-current-linux-amd64.tar.xz; export DISTRO_TARBALL_ASC_NAME=$DISTRO_TARBALL_NAME.asc`
- `gpg --keyserver hkp://pgp.mit.edu --recv-keys $GPG_KEY || gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys $GPG_KEY || gpg --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys $GPG_KEY`
- `wget http://skylark.tsu.ru/art/master/$DISTRO_TARBALL_NAME`
- `wget http://skylark.tsu.ru/art/master/$DISTRO_TARBALL_ASC_NAME`
- `gpg --verify                          $DISTRO_TARBALL_ASC_NAME`
- `sudo tar xf                           $DISTRO_TARBALL_NAME -C /usr --skip-old-files`

### Other OS/distros
#### System-wide
- `git clone https://github.com/larkvirtual/restracer.git`
- `cd restracer`
- `cat DEPENDS.txt`
- `make -j$(nproc)`
- `sudo make install`
#### User-only
- `git clone https://github.com/larkvirtual/restracer.git`
- `cd restracer`
- `cat DEPENDS.txt`
- `make -j$(nproc)`
- `DESTDIR=usr-local make install`

## Use
### Userspace (CLI/Daemon applications)
- System-wide: no extra commands needed
- User-only: `export PATH=$PATH:PATH-TO-RESTRACER/usr-local/bin; export RT_ROOT=PATH-TO-RESTRACER/usr-local`
#### Networked method (traced application writes to socket, analyzer runs in the same time)
- `cd src`
- Put `art_start("myApp;autostart;");` call is a first function inside your `main()`
- `GNU Make@GNU/Linux:` `rt-make`
- `GNU Make@FreeBSD:` `rt-gmake`
- `BSD Make@FreeBSD:` `rt-make`
- `restracer ./myApp`
##### Pros
- Analyzer (`artrepgen`) can run on some remote location, outside of traced program / container
##### Cons
- Less easy to debug restracer itself
- Network throughput performance may be primary importance

#### Tracefile method (traced application writes to tracefile, then finishes noramally or not, then passing tracefile to analyzer)
- `cd src`
- Put `art_start("");` call is a first function inside your `main()`
- `GNU Make@GNU/Linux:` `RT_TEMPLATE=posix-gcc-mt-file-lint rt-make`
- `GNU Make@FreeBSD:` `RT_TEMPLATE=posix-gcc-mt-file-lint rt-gmake`
- `BSD Make@FreeBSD:` `RT_TEMPLATE=posix-gcc-mt-file-lint rt-make`
- `restracer ./myApp`
- `artrepgen --file tracefile.out`
#### Pros
- More easy to debug restracer itself
- Less tricky to run Analyzer (`artrepgen`)
#### Cons
- Can consume *lots* of diskspace

## Kernel

# Uninstall
## Gentoo (WILL ERASE `/usr/lib64/`: `libffi.so.6`, `libglibmm-2.4.so.1`, `libgobject-2.0.so.0`, `libsigc-2.0.so.0`, `libglib-2.0.so.0`, `libgmodule-2.0.so.0`, `libpcre.so.3`, `libxml++-2.6.so.2`. DO NOT EXECUTE IF UNSURE
- `export GPG_KEY=B0414424; export DISTRO_TARBALL_NAME=restracer-current-linux-amd64.tar.xz; export DISTRO_TARBALL_ASC_NAME=$DISTRO_TARBALL_NAME.asc`
- `gpg --delete-keys --yes $GPG_KEY`
- `cd /usr; tar tf PATH-TO/restracer-current-linux-amd64.tar.xz | xargs rm -f`
- `rm -rf /usr/local/lib/restracer/`
- `rm -f $DISTRO_TARBALL_ASC_NAME        $DISTRO_TARBALL_NAME`

## Other OS/distros
### System-wide
- `cd restracer`
- `sudo make uninstall`
- `cd ..`
- `rm -rf restracer`
### User-only
- `rm -rf restracer`
