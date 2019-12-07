#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}

answer=$(grep -s '/mnt/sd ' /proc/mounts  2>&1)

case $? in
  0 )
    logfile=/tmp/sdmountinfo_$(date +%Y%m%d_%H%M%S)_$(basename $0).log
    echo "$answer" > $logfile
    $ksmroot/kbmessage.sh "-f $logfile"
    ;;
  * ) echo "There is no external sd mounted"
    ;;
esac
