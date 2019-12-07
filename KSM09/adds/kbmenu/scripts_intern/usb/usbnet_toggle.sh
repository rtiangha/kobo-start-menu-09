#!/bin/sh

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
  if [ $CPU == mx6sll ] || [ $CPU == mx6ull ]; then
    rmmod usb_f_rndis
    rmmod usb_f_ecm_subset
    rmmod usb_f_eem
    rmmod usb_f_ecm
    rmmod u_ether
    rmmod libcomposite
    rmmod configfs
  else
    rmmod arcotg_udc
  fi
  mode="down"
fi

[ "$mode" == "down" ] && exit

driver_root=/drivers/$PLATFORM/usb/gadget

if [ ! -f /var/run/dropbear.pid ] && [ "$useDropbear" == "true" ] && [ -x "$vlasovsoft_dropbear/dropbear" ]; then
  [ ! -e /usr/libexec/sftp-server ] && (mkdir -p /usr/libexec; ln -sf $vlasovsoft_dropbear/sftp-server /usr/libexec/sftp-server)
  $vlasovsoft_dropbear/dropbear -E -r $vlasovsoft_dropbear/host.key.rsa -d $vlasovsoft_dropbear/host.key.dss > $vlasovsoft_dropbear/dropbear.log 2>&1
fi

if [ $CPU == mx6sll ] || [ $CPU == mx6ull ]; then
  insmod $driver_root/configfs.ko
  insmod $driver_root/libcomposite.ko
  insmod $driver_root/u_ether.ko
  insmod $driver_root/usb_f_ecm.ko
  insmod $driver_root/usb_f_eem.ko
  insmod $driver_root/usb_f_ecm_subset.ko
  insmod $driver_root/usb_f_rndis.ko
  insmod $driver_root/g_ether.ko use_eem=0 host_addr=46:0d:9e:67:69:eb dev_addr=46:0d:9e:67:69:ec
else
  insmod $driver_root/arcotg_udc.ko
  insmod $driver_root/g_ether.ko host_addr=46:0d:9e:67:69:eb dev_addr=46:0d:9e:67:69:ec
fi

ifconfig usb0 192.168.2.101
