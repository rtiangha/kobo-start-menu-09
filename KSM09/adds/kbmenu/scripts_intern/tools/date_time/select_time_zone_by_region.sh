#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
zonehelper=$ksmroot/helpers/select_time_zone_region.msh
. $ksmroot/onstart/exp_block

regions="Africa America Antarctica Arctic Asia Atlantic Australia Brazil Canada Chile Etc Europe India Mexico MIdeast Pacific US"
selectedoption=
while [ "$selectedoption" != "EXIT" ]; do
  selectedoption=$($ksmroot/kobomenu $regions return:arrowup.png return_home:arrowup.png -qws)
  case "$selectedoption" in
    return)  selectedoption="EXIT";;
    return_home)
      selectedoption="EXIT"
      echo "return_home"
      ;;
    *)
      $zonehelper "$selectedoption"
      selectedoption="EXIT"
      ;;
  esac
done
