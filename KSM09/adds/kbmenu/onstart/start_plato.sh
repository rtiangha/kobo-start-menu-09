#! /bin/sh

# todo: maybe warn when wifi is on?

#${platobasedir}/plato.sh
cd "${platobasedir}" || exit 1
export LD_LIBRARY_PATH="libs:${LD_LIBRARY_PATH}"
export MODEL_NUMBER=$(cut -f 6 -d ',' /mnt/onboard/.kobo/version | sed -e 's/^[0-]*//')
./plato > info.log 2>&1 || mv info.log crash.log

# todo: maybe warn when wifi is on?
