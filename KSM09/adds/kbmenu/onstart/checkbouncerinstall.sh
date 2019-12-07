#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
bouncerdir=$ksmroot/kbbouncer

if [ ! -e $bouncerdir/kbbouncer ] || [ ! -e $bouncerdir/kbbouncer.sh ] 
then
  echo "failed"
else
  echo "ok"
fi 
