#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}

if [ -e $ksmroot/onstart/poweroff.sh ]; then
  $ksmroot/onstart/poweroff.sh
else
  /sbin/poweroff
fi
