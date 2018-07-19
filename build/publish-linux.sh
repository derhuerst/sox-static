#!/bin/sh
set +e
cd $(dirname $(dirname $(realpath $0)))

cp sox-src/src/sox packages/sox-static-linux/
cp -r sox-src/src/.libs packages/sox-static-linux/
cp sox-src/AUTHORS packages/sox-static-linux/
cp sox-src/LICENSE.LGPL packages/sox-static-linux/LICENSE
cp sox-src/README packages/sox-static-linux/_README
cp sox-src/README.osx packages/sox-static-linux/_README.osx

cd packages/sox-static-linux
ls -lh .

npm i semver --no-save
npm version --no-git-tag-version --force $(./node_modules/.bin/semver -i minor $(npm info sox-static-linux version))
echo "//registry.npmjs.org/:_authToken=$NPM_KEY" >~/.npmrc
npm publish
