#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

moptions="delete_ksm cancel"


while [ "$selection" != "EXIT" ]; do
  selection=$($ksmroot/kobomenu.sh $moptions)
  case $selection in
    cancel )
      selection="EXIT"
      ;;
    delete_ksm )
      rm -rf $ksmroot
      rm -rf $ksmuser
      reboot
      ;;
  esac
done
