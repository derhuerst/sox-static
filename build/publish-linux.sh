#!/bin/sh
set +e
cd $(dirname $(dirname $(realpath $0)))

cp sox-src/src/sox packages/sox-static-linux/
cp sox-src/AUTHORS packages/sox-static-linux/
cp sox-src/LICENSE.LGPL packages/sox-static-linux/LICENSE
cp sox-src/README packages/sox-static-linux/_README
cp sox-src/README.osx packages/sox-static-linux/_README.osx

cd packages/sox-static-linux
ls -lh .

npm publish
