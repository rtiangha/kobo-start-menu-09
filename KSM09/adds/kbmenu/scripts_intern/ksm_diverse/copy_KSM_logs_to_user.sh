#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

if [ -d $ksmuser ]; then
  mkdir -p $ksmuser/log
  cp $ksmroot/log/* $ksmuser/log/
fi
