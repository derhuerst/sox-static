#!/bin/bash
set -euo pipefail
cd $(dirname $(dirname $(realpath $0)))

tar_exec=$(command -v gtar)
if [ $? -ne 0 ]; then
	tar_exec=$(command -v tar)
fi

# todo: there are more recent releases on https://codeberg.org/sox_ng/sox_ng/releases

curl -L -# -o sox.tar.gz 'https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz'
$tar_exec -x -z -C sox-src --strip-components 1 -f sox.tar.gz
