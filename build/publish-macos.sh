#!/bin/sh
set +e
cd $(dirname $(dirname $(realpath $0)))

cp sox-src/src/sox packages/sox-static-macos/
cp sox-src/AUTHORS packages/sox-static-macos/
cp sox-src/LICENSE.LGPL packages/sox-static-macos/LICENSE
cp sox-src/README packages/sox-static-macos/_README
cp sox-src/README.osx packages/sox-static-macos/_README.osx

cd packages/sox-static-macos
ls -lh .

echo "//registry.npmjs.org/:_authToken=$NPM_KEY" >~/.npmrc
npm publish
