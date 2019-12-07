#!/bin/sh

clean_up_after_koreader_in_any_case=${clean_up_after_koreader_in_any_case:-"false"}

if [ "$clean_up_after_koreader_in_any_case" == "true" ] || [ $( lsof | grep 'koreader.*/fonts' | awk 'NR==1 { print $1 }') -gt 0 ]; then

  [ $(ps | grep -c wlarm_le) -gt 0 ] && wlarm_le -i eth0 down
  ifconfig eth0 down
  [ $(lsmod | grep -c dhd) -gt 0 ] && /sbin/rmmod -r dhd
  [ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ] && /sbin/rmmod -r sdio_wifi_pwr
  killall udhcpc default.script wpa_supplicant 2>/dev/null

# try to kill all processes that keep koreader font files open
  while :
  do
    p=$( lsof | grep 'koreader.*/fonts' | awk 'NR==1 { print $1 }')
    [ "x$p" == "x" ] && break
    kill $p
    [ $? -gt 0 ] && break
  done
fi
