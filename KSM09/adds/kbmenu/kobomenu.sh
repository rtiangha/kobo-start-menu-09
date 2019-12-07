#!/bin/sh

source $ksmroot/onstart/exp_block

if [ "$mrotation" == "0" ] && [ "x$ksmGeometryValuesE" != "x" ]; then
  moption=$($ksmroot/kobomenu $* -qws -geometry $ksmGeometryValuesE $ksmcolors)
elif [ "$mrotation" == "90" ] && [ "x$ksmGeometryValuesN" != "x" ]; then
  moption=$($ksmroot/kobomenu $* -qws -geometry $ksmGeometryValuesN $ksmcolors)
elif [ "$mrotation" == "180" ] && [ "x$ksmGeometryValuesW" != "x" ]; then
  moption=$($ksmroot/kobomenu $* -qws -geometry $ksmGeometryValuesW $ksmcolors)
elif [ "$mrotation" == "270" ] && [ "x$ksmGeometryValuesS" != "x" ]; then
  moption=$($ksmroot/kobomenu $* -qws -geometry $ksmGeometryValuesS $ksmcolors)
else
  moption=$($ksmroot/kobomenu $* -qws $ksmcolors)
fi
echo "$moption"
