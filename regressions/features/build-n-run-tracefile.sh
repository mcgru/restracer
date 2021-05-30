#!/bin/sh

SED=$(type gsed > /dev/null && echo gsed || echo sed)

passOK=0
passFAILED=0
FAILEDlist=""
total=0

for d in `find . -type d -name "0[0-9]*" | sort`; do
#    pushd . > /dev/null
    d=`echo $d | ${SED} 's/\.\///g' -`
    if [ "$d" = 019 ]; then
        RT_TEMPLATE=posix-gcc-mt-file-special
    else
        RT_TEMPLATE=posix-gcc-mt-file-lint
    fi

    cd "$d" && CFLAGS="${CFLAGS} -g -ggdb" RT_TEMPLATE=$RT_TEMPLATE rt-gmake \
    && ./main || true
    artrepgen --file tracefile.out > .real
    ${SED} -r -i 's/[0-9A-Z]{16}//g' .real
    diff -u .real .right
    if [ $? -eq 0 ]; then
        rm .real
        mv tracefile.out .tracefile.out
        passOK=$((passOK+1))
        echo "$i OK";
    elif [ -f .right-freebsd ]; then # FreeBSD specific behavior handling
        diff -u .real .right-freebsd
        if [ $? -eq 0 ]; then
            rm .real
            mv tracefile.out .tracefile.out
            passOK=$((passOK+1))
            echo "$i OK";
        else
            passFAILED=$((passFAILED+1))
            echo "$i FAILED"
            FAILEDlist="$FAILEDlist $d"
            mv tracefile.out .tracefile.out
        fi
    else
        passFAILED=$((passFAILED+1))
        echo "$i FAILED"
        FAILEDlist="$FAILEDlist $d"
        mv tracefile.out .tracefile.out
    fi

    total=$((total+1))
 #   popd    > /dev/null
    cd ..
done

echo '******************************************************************************'
echo '* WARNING: if template art_start_selfinit="false" => 018/main.c WILL FAIL!!! *'
echo "* THIS IS TOTALLY FINE, CUZ 018.c doesn't contain art_start()                *"
echo '******************************************************************************'

echo "-------------------------------------"
echo "TOTAL PASSED: $passOK/$total"
echo "TOTAL FAILED: $passFAILED"
if [ "$FAILEDlist" != "" ]; then
    echo "FAILED list: $FAILEDlist"
    exit 1
fi
