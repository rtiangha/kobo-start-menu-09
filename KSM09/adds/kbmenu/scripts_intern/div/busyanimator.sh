#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}

busyimagesbasename=${busyimagesbasename:-"arrow"}

[ -e "${ksmroot}/images/${busyimagesbasename}0.png" ] || exit

i=0;
while true; do
  if [ -e "${ksmroot}/images/${busyimagesbasename}${i}.png" ]; then
    $ksmroot/tools/pngshow "${ksmroot}/images/${busyimagesbasename}${i}.png"
    let ++i
    usleep 250000
  else
    i=0
  fi
done
