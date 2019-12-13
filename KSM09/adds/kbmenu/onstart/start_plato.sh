#! /bin/sh

# todo: set rotation value for the different device models
# currently I know only for sure that trilogy|kraken|alyssum|daylight need 3
case $PRODUCT in
  dragon|dahlia|snow ) platoRotate="1";;
  * ) platoRotate="3";;
esac

if [ "${platoRotate}" != "$(cat /sys/class/graphics/fb0/rotate)" ]; then
  echo "${platoRotate}" > /sys/class/graphics/fb0/rotate
  if [ "${platoRotate}" != "$(cat /sys/class/graphics/fb0/rotate)" ]; then
    echo "$((platoRotate ^ 2))" > /sys/class/graphics/fb0/rotate
  fi
fi

# todo: maybe warn when wifi is on?

#${platobasedir}/plato.sh
cd "${platobasedir}" || exit 1
export LD_LIBRARY_PATH="libs:${LD_LIBRARY_PATH}"
mount -o remount,rw /mnt/sd
./plato > info.log 2>&1 || mv info.log crash.log

# todo: maybe warn when wifi is on?
