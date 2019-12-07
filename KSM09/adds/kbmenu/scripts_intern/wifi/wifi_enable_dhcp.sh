#!/bin/sh

#export PATH=$PATH:/sbin:/usr/sbin

#root=/mnt/onboard/.kobo/KoboLauncher/usbnet

lsmod | grep -q sdio_wifi_pwr || insmod /drivers/$PLATFORM/wifi/sdio_wifi_pwr.ko
lsmod | grep -q ${WIFI_MODULE} || insmod /drivers/$PLATFORM/wifi/${WIFI_MODULE}.ko

loopscount=0
while [ ! -e /sys/class/net/${INTERFACE} ] && [ ${loopscount} -lt 12 ]; do
  let loopscount++
  sleep 0.2
done

ifconfig ${INTERFACE} up
[ ${WIFI_MODULE} = 8189fs ] || [ ${WIFI_MODULE} = 8189es ] || wlarm_le -i ${INTERFACE} up

if ! pidof wpa_supplicant >/dev/null; then
  wpa_supplicant -D nl80211,wext -s -i ${INTERFACE} -c /etc/wpa_supplicant/wpa_supplicant.conf -C /var/run/wpa_supplicant -B
  if [ "$?" -ne "0" ]; then
    wpa_supplicant -s -i ${INTERFACE} -c /etc/wpa_supplicant/wpa_supplicant.conf -C /var/run/wpa_supplicant -B
    if [ "$?" -ne "0" ]; then
      wlarm_le -i ${INTERFACE} down
      ifconfig ${INTERFACE} down
      /sbin/rmmod -r ${WIFI_MODULE}
      /sbin/rmmod -r sdio_wifi_pwr
      exit
    fi
  fi
fi

#sleep 1

#if you need dhcp/dynamic uncomment next and comment the 'ip ad below'
/sbin/udhcpc -S -i ${INTERFACE} -s /etc/udhcpc.d/default.script -t15 -T10 -A3 -b -q >/dev/null 2>&1 &

#ip ad add 192.168.2.101/24 dev ${INTERFACE}


#touch /var/log/lastlog
#$root/dropbear -p 22 -E -r $root/host.key.rsa -d $root/host.key.dss

