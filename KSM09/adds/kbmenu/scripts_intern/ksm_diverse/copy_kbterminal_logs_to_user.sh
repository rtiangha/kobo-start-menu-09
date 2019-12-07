#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

if [ -d $ksmuser ]; then
  mkdir -p $ksmuser/kbterminal_logs
  cp $ksmroot/kbterminal/*.txt $ksmuser/kbterminal_logs/
fi
