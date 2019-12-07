#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
poff=$ksmroot/replacements/poweroff

if [ -e $poff ]; then
  cp $poff /sbin/poweroff
  chmod +x /sbin/poweroff
fi
