#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

if [ "$KSMdebugmode" == "true" ]; then
  $ksmroot/kbmessage.sh "Please disable debug mode before deleting log files!"
  exit
fi

rm -f $ksmroot/log/*
[ -d $ksmuser/log ] && rm -f $ksmuser/log/*
