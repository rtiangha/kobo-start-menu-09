#!/bin/sh

source $ksmroot/onstart/exp_block

if [ "$mrotation" == "0" ] && [ "x$ksmGeometryValuesE" != "x" ]; then
  $ksmroot/kbmessage $* -qws -geometry $ksmGeometryValuesE
elif [ "$mrotation" == "90" ] && [ "x$ksmGeometryValuesN" != "x" ]; then
  $ksmroot/kbmessage $* -qws -geometry $ksmGeometryValuesN
elif [ "$mrotation" == "180" ] && [ "x$ksmGeometryValuesW" != "x" ]; then
  $ksmroot/kbmessage $* -qws -geometry $ksmGeometryValuesW
elif [ "$mrotation" == "270" ] && [ "x$ksmGeometryValuesS" != "x" ]; then
  $ksmroot/kbmessage $* -qws -geometry $ksmGeometryValuesS
else
  $ksmroot/kbmessage $* -qws
fi
