#!/bin/sh

source $ksmroot/onstart/exp_block

if [ "$mrotation" == "0" ] && [ "x$ksmGeometryValuesE" != "x" ]; then
  $ksmroot/imageviewer $* -qws -geometry $ksmGeometryValuesE
elif [ "$mrotation" == "90" ] && [ "x$ksmGeometryValuesN" != "x" ]; then
  $ksmroot/imageviewer $* -qws -geometry $ksmGeometryValuesN
elif [ "$mrotation" == "180" ] && [ "x$ksmGeometryValuesW" != "x" ]; then
  $ksmroot/imageviewer $* -qws -geometry $ksmGeometryValuesW
elif [ "$mrotation" == "270" ] && [ "x$ksmGeometryValuesS" != "x" ]; then
  $ksmroot/imageviewer $* -qws -geometry $ksmGeometryValuesS
else
  $ksmroot/imageviewer $* -qws
fi
