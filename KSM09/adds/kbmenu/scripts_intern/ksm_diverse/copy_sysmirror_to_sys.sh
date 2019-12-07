#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}
theexec=$ksmroot/tools/rsync

if [ -d "$ksmuser/sysmirror" ]; then
  # cp -rfp "$ksmuser/sysmirror/." /
$theexec -a "$ksmuser/sysmirror/" /
else
  $ksmroot/kbmessage.sh "cannot find $ksmuser/sysmirror/"
fi
