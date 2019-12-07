#! /bin/sh

#${platobasedir}/plato.sh

cd "${platobasedir}" || exit 1
export LD_LIBRARY_PATH="libs:${LD_LIBRARY_PATH}"
./plato > info.log 2>&1 || mv info.log crash.log


