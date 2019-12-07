#!/bin/sh

source $ksmroot/onstart/exp_block


if [ "$mrotation" == "0" ] && [ "x$ksmGeometryValuesE" != "x" ]; then
  answer=$($ksmroot/kbconfsel "$@" -qws -geometry $ksmGeometryValuesE $ksmcolors)
elif [ "$mrotation" == "90" ] && [ "x$ksmGeometryValuesN" != "x" ]; then
  answer=$($ksmroot/kbconfsel "$@" -qws -geometry $ksmGeometryValuesN $ksmcolors)
elif [ "$mrotation" == "180" ] && [ "x$ksmGeometryValuesW" != "x" ]; then
  answer=$($ksmroot/kbconfsel "$@" -qws -geometry $ksmGeometryValuesW $ksmcolors)
elif [ "$mrotation" == "270" ] && [ "x$ksmGeometryValuesS" != "x" ]; then
  answer=$($ksmroot/kbconfsel "$@" -qws -geometry $ksmGeometryValuesS $ksmcolors)
else
  answer=$($ksmroot/kbconfsel "$@" -qws $ksmcolors)
fi

echo "$answer"
