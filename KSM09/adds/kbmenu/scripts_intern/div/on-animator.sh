#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}

busyimagesbasename=${busyimagesbasename:-"arrow"}

[ -e "${ksmroot}/images/${busyimagesbasename}0.png" ] || exit

if [ "x$animationDurationS" == "x" ]; then
  animationDurationS=0.25
else

# add leading zero if string starts with a dot
  case $animationDurationS in
    .* ) animationDurationS="0$animationDurationS";;
  esac

# remove trailing zeros and dots
  trailingzerosremoved=false
  while [ "$trailingzerosremoved" == "false" ]; do
    case $animationDurationS in
      *.*0 | *.) animationDurationS=$(echo ${animationDurationS} | awk '{print substr($0, 0, length($0)-1)}');;
      *) trailingzerosremoved=true;
    esac
  done

# set to 0.25 if it is not a number
  numbtest=$(echo ${animationDurationS} 0 | awk '{print $1 + $2}')
  if [ "x${animationDurationS}" != "x${numbtest}" ]; then
    animationDurationS=0.25
  fi
fi

i=0;
while true; do
  if [ -e "${ksmroot}/images/${busyimagesbasename}${i}.png" ]; then
    $ksmroot/tools/pngshow "${ksmroot}/images/${busyimagesbasename}${i}.png"
    let ++i
    sleep $animationDurationS
  else
    i=0
  fi
done
