#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
zonesdir=/etc/zoneinfo
optionlist="/Asia/Tokyo /Europe/Paris Europe/Vienna"


infotext="current_zone:"
selectedoption=

while [ "$selectedoption" != "EXIT" ]; do
  infotext=$(date +"%Z": date +"%FORMAT")
  infotext=${infotext// /_}
  infotext="$infotext<br/>$selectedoption"
  selectedoption=$($ksmroot/kobomenu -infotext=$infotext -infolines=2 $optionlist return:arrowup.png return_home:arrowup.png -qws)
  case "$selectedoption" in
    return)  selectedoption="EXIT";;
    return_home)
      selectedoption="EXIT"
      echo "return_home"
      ;;
    *)
      ln -sf "$zonesdir$selectedoption" "/etc/localtime"
      ;;
  esac
done
