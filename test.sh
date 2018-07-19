#!/bin/sh

bin=$(node -e 'process.stdout.write(require("."))')
$bin -q -t raw -c 2 -b 16 - trim 0 5 >/dev/null
