#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

rm -f $ksmroot/kbterminal/*.txt
[ -d $ksmuser/kbterminal_logs ] && rm -f $ksmuser/kbterminal_logs/*
