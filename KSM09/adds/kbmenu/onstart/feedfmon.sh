#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}

fmondir=${ksmroot}/tools
fmonshdir=${ksmroot}/fmonsh
pngdir=/mnt/onboard/kbmenupngs

if [ -e $fmondir/fmon ]; then
  for file in "${fmonshdir}"/*.sh; do
    filename=$(basename "${file}" .sh)
    if [ -e $pngdir/$filename\.png ] &&\
      [ $($ksmroot/tools/sqlite3 /mnt/onboard/.kobo/KoboReader.sqlite "select ContentID from content where ContentID = 'file://$pngdir/$filename.png'") != "" ]
    then
      "${fmondir}/fmon" "${pngdir}/${filename}.png" "${fmonshdir}/${filename}.sh" >> "${fmondir}/fmon.log.txt" 2>&1 &
    fi
  done
fi
