#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}

delwpasupplicant=$($ksmroot/kobomenu.sh -infolines=1 "-infotext=""delete_wpa_supplicant.conf?" "yes no")
case ${delwpasupplicant} in
  yes )
    rm -f /etc/wpa_supplicant/wpa_supplicant.conf;;
esac


