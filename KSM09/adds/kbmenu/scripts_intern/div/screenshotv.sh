#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
prog=$ksmroot/tools/fbgrab
targetfile=/mnt/onboard/screen_$(date +%Y%m%d_%H%M%S)

if [ -e $prog ]; then
  $prog -v $targetfile\.png >$targetfile\.log 2>&1
else
  cat /dev/fb0 > $targetfile\.raw
fi
