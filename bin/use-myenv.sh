#!/bin/bash

#usage:
# source use-myenv.sh 

myenvfile="$1"
test -f "${myenvfile}" &&
    export doing_extra_setting="${myenvfile}" ||
    echo "err: my envfile invliad, no such file: (${myenvfile})"


