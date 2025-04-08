#!/bin/bash
set -euo pipefail
cd $(dirname $(dirname $(realpath $0)))

cd sox-src

./configure
make -s
./src/sox -h
