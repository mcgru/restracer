#!/bin/sh

SED=$(type gsed > /dev/null 2> /dev/null && echo gsed || echo sed)

passOK=0
passFAILED=0
OKlist=""
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

    if [ "$d" = 020 ]; then #####
        RT_MAKE_CHK_INSTRUM_ARG=1
        RT_DYNAMIC_ARG=1

        cd "$d" && \
        CFLAGS="${CFLAGS} -g -ggdb" RT_TEMPLATE=$RT_TEMPLATE \
        RT_DYNAMIC=$RT_DYNAMIC_ARG rt-gmake \
        &&                          RT_TEMPLATE=$RT_TEMPLATE \
        RT_CHK_INSTRUM=$RT_MAKE_CHK_INSTRUM_ARG restracer ./main 2> restracer-err.txt || true
        grep "calling not from restracer wrapper (0x"               restracer-err.txt > /dev/null
        if [ $? = 0 ]; then
            passOK=$((passOK+1))
            OKlist="$OKlist $d"
            echo "$i OK";
        else
            passFAILED=$((passFAILED+1))
            FAILEDlist="$FAILEDlist $d"
            echo "Unexpected restracer-err.txt content:"
            cat restracer-err.txt
            echo "-------------------"
        fi

    else ########################
        RT_MAKE_CHK_INSTRUM_ARG=0
        RT_DYNAMIC_ARG=0

        cd "$d" && \
        CFLAGS="${CFLAGS} -g -ggdb" RT_TEMPLATE=$RT_TEMPLATE RT_DYNAMIC=$RT_DYNAMIC_ARG rt-gmake \
        && RT_CHK_INSTRUM=$RT_MAKE_CHK_INSTRUM_ARG restracer ./main || true
        artrepgen --file tracefile.out > .real
        ${SED} -r -i 's/[0-9A-Z]{16}//g' .real
        diff -u .real .right
        if [ $? -eq 0 ]; then
            rm .real
            mv tracefile.out .tracefile.out
            passOK=$((passOK+1))
            OKlist="$OKlist $d"
            echo "$i OK";
        elif [ -f .right-freebsd ]; then # FreeBSD specific behavior handling
            diff -u .real .right-freebsd
            if [ $? -eq 0 ]; then
                rm .real
                mv tracefile.out .tracefile.out
                passOK=$((passOK+1))
                OKlist="$OKlist $d"
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

    fi
    total=$((total+1))

 #   popd    > /dev/null
    cd ..
done

echo '******************************************************************************'
echo '* WARNING: if template art_start_selfinit="false" => 018/main.c WILL FAIL!!! *'
echo "* THIS IS TOTALLY FINE, BECAUSE 018.c doesn't contain art_start()                *"
echo '******************************************************************************'

echo "-------------------------------------"
echo "TOTAL PASSED: $passOK/$total"
if [ "$OKlist" != "" ]; then
    echo "OK list: $OKlist"
fi
echo "TOTAL FAILED: $passFAILED"
if [ "$FAILEDlist" != "" ]; then
    echo "FAILED list: $FAILEDlist"
    exit 1
fi
