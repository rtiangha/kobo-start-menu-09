#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

if [ "$fbrotatevalue" != "$(cat /sys/class/graphics/fb0/rotate)" ]; then
  echo "$fbrotatevalue" > /sys/class/graphics/fb0/rotate
  cat /sys/class/graphics/fb0/rotate > /sys/class/graphics/fb0/rotate
fi

if [ "x$poweroffRandomdir" != "x" ]; then
  pofile=$($ksmroot/helpers/getrandomfile.sh $poweroffRandomdir "*.html" "*.htm")
  export mrotation="$poweroffRotation"
fi

pofile=${pofile:-"$ksmuser/txt/poweroff_info.html"}
$ksmroot/kbmessage.sh "-f $pofile"

#$ksmroot/kbmessage.sh "-f $pofile" &
#usleep 400000
#/bin/busybox poweroff
