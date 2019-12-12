#!/bin/sh

if [ $CPU == mx6sll ] || [ $CPU == mx6ull ]; then
  exit
fi

useDropbear=${useDropbear:-"false"}

  if [ -x ${vlasovsoftbasedir}/dropbear/dropbear ]; then
    vlasovsoft_dropbear=${vlasovsoftbasedir}/dropbear
  elif [ -x ${vlasovsoftbasedir}/usbnet/dropbear ]; then
    vlasovsoft_dropbear=${vlasovsoftbasedir}/usbnet
  fi



mode="up"
if [ -f /var/run/dropbear.pid ] && [ "$useDropbear" == "true" ] && [ -d "$vlasovsoft_dropbear" ]; then
  kill `cat /var/run/dropbear.pid`
  mode="down"
fi

if ifconfig | grep -q usb0; then
  ifconfig usb0 down
  rmmod g_ether
  rmmod arcotg_udc
  mode="down"
fi

[ "$mode" == "down" ] && exit

driver_root=/drivers/$PLATFORM/usb/gadget

if [ ! -f /var/run/dropbear.pid ] && [ "$useDropbear" == "true" ] && [ -x "$vlasovsoft_dropbear/dropbear" ]; then
  [ ! -e /usr/libexec/sftp-server ] && (mkdir -p /usr/libexec; ln -sf $vlasovsoft_dropbear/sftp-server /usr/libexec/sftp-server)
  $vlasovsoft_dropbear/dropbear -E -r $vlasovsoft_dropbear/host.key.rsa -d $vlasovsoft_dropbear/host.key.dss > $vlasovsoft_dropbear/dropbear.log 2>&1
fi

insmod $driver_root/arcotg_udc.ko
insmod $driver_root/g_ether.ko host_addr=46:0d:9e:67:69:eb dev_addr=46:0d:9e:67:69:ec
ifconfig usb0 192.168.2.101
