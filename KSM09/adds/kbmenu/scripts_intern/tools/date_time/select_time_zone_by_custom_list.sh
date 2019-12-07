#!/bin/sh

#Note the underscore in "New York"
optionlist="/Asia/Tokyo /America/New_York /Europe/Paris"

ksmroot=${ksmroot:-"/adds/kbmenu"}

zonesdir=/etc/zoneinfo


selectedoption=

while [ "$selectedoption" != "EXIT" ]; do
infotext=$(date)
infotext=${infotext// /_}
  selectedoption=$($ksmroot/kobomenu -infotext=$infotext -infolines=2 $optionlist return:arrowup.png return_home:arrowup.png -qws)
  case "$selectedoption" in
    return)  selectedoption="EXIT";;
    return_home)
      selectedoption="EXIT"
      echo "return_home"
      ;;
    *)
      ln -sf "$zonesdir$selectedoption" "/etc/localtime"
      selectedoption="EXIT"
      ;;
  esac
done
