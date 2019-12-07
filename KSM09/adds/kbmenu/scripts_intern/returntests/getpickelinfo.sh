#!/bin/sh

#the idea was to insert this into rcS in order to save upstart time
#but it is not worth the effort

ksmroot=${ksmroot:-"/adds/kbmenu"}
kobodir=/usr/local/Kobo

pickel_id=0
thispickel_id=$(stat -c%Y $kobodir)
if [ -f $ksmroot/info_pickel ]; then
  . $ksmroot/info_pickel
  message="read_from_file"
fi
if [ "$pickel_id" != "$thispickel_id" ]; then
  if  [ $(strings /usr/local/Kobo/pickel | grep -c ld-linux-armhf.so) -ge 1 ]; then
    isarmhf="TRUE"
    if [ $(strings /usr/local/Kobo/pickel | grep -c can-upgrade) -ge 1 ]; then
      newpickelversion="TRUE"
    fi
  else
    isarmhf="FALSE"
    newpickelversion="FALSE"
  fi
  if [ -d "$ksmroot" ]; then
    echo "pickel_id=$thispickel_id" > $ksmroot/info_pickel
    echo "isarmhf=$isarmhf" >> $ksmroot/info_pickel
    echo "newpickelversion=$newpickelversion" >> $ksmroot/info_pickel
    message="written_to_file"
  fi
fi

echo "$message<br> isarmhf=$isarmhf<br> newpickelversion=$newpickelversion"
