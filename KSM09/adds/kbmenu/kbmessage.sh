#!/bin/sh

source $ksmroot/onstart/exp_block

if [ "$mrotation" == "0" ] && [ "x$ksmGeometryValuesE" != "x" ]; then
  $ksmroot/kbmessage $* -qws -geometry $ksmGeometryValuesE $ksmcolors
elif [ "$mrotation" == "90" ] && [ "x$ksmGeometryValuesN" != "x" ]; then
  $ksmroot/kbmessage $* -qws -geometry $ksmGeometryValuesN $ksmcolors
elif [ "$mrotation" == "180" ] && [ "x$ksmGeometryValuesW" != "x" ]; then
  $ksmroot/kbmessage $* -qws -geometry $ksmGeometryValuesW $ksmcolors
elif [ "$mrotation" == "270" ] && [ "x$ksmGeometryValuesS" != "x" ]; then
  $ksmroot/kbmessage $* -qws -geometry $ksmGeometryValuesS $ksmcolors
else
  $ksmroot/kbmessage $* -qws $ksmcolors
fi
