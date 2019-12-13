#! /bin/sh

# todo: maybe warn when wifi is on?

#${platobasedir}/plato.sh
cd "${platobasedir}" || exit 1
export LD_LIBRARY_PATH="libs:${LD_LIBRARY_PATH}"
mount -o remount,rw /mnt/sd
./plato > info.log 2>&1 || mv info.log crash.log

# todo: maybe warn when wifi is on?
