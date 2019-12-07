#!/bin/sh
#refreshrate in seconds
refreshrate=60

ksmroot=${ksmroot:-"/adds/kbmenu"}
getinfo() {
  info=""
  for el in capacity status voltage_now current_now charge_now type ; do
    info="$info $el `cat /sys/devices/platform/pmic_battery.1/power_supply/mc13892_bat/$el`<br>"
  done;
  info=${info// /_}
  echo $info
}

moptions="refresh return:arrowup.png return_home:arrowup.png"

selection=""
while [ "$selection" != "EXIT" ]; do
  infotext=$(getinfo)
  selection=$($ksmroot/kobomenu.sh -autoselectafter=$refreshrate -autoselectoption=refresh -infolines=8 "-infotext=$infotext" $moptions)
  case $selection in
    return)  selection="EXIT";;
    return_home)
      selection="EXIT"
      echo "return_home"
      ;;
    *)
      ;;
  esac
done
