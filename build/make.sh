#!/bin/sh
set +e
cd $(dirname $(dirname $(realpath $0)))
cd sox-src

./configure
make -s
cp src/sox ../sox
