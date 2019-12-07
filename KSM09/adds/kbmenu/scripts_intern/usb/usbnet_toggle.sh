#!/bin/sh

if [ $CPU == mx6sll ] || [ $CPU == mx6ull ]; then
  exit
fi

useDropbear=${useDropbear:-"false"}
vlasovsoft_usbnet=$vlasovsoftbasedir/usbnet

ksmroot=${ksmroot:-"/adds/kbmenu"}
if [ "$KSMdebugmode" == "true" ]; then
  debug_logfile=$ksmroot/log/ksmdebug_$(date +%Y%m%d_%H%M%S)_$(basename $0).log
  echo "started: $(date +%Y%m%d_%H%M%S)" > $debug_logfile
  echo "script path: $0" >> $debug_logfile
  echo "ksmroot: $ksmroot" >> $debug_logfile
  echo "useDropbear: $useDropbear" >> $debug_logfile
fi




mode="up"
if [ -f /var/run/dropbear.pid ] && [ "$useDropbear" == "true" ] && [ -d "$vlasovsoft_usbnet" ]; then
  [ "$KSMdebugmode" == "true" ] && echo "dropbear.pid: existed" >> $debug_logfile
  kill `cat /var/run/dropbear.pid`
  mode="down"
fi

if ifconfig | grep -q usb0; then
  [ "$KSMdebugmode" == "true" ] && echo "usb0: was up" >> $debug_logfile
  ifconfig usb0 down
  rmmod g_ether
  rmmod arcotg_udc
  mode="down"
fi

[ "$mode" == "down" ] && exit

driver_root=/drivers/$PLATFORM/usb/gadget

if [ ! -f /var/run/dropbear.pid ] && [ "$useDropbear" == "true" ] && [ -d "$vlasovsoft_usbnet" ]; then
  [ ! -e /usr/libexec/sftp-server ] && (mkdir -p /usr/libexec; ln -sf $vlasovsoft_usbnet/sftp-server /usr/libexec/sftp-server)
  $vlasovsoft_usbnet/dropbear -E -r $vlasovsoft_usbnet/host.key.rsa -d $vlasovsoft_usbnet/host.key.dss > $vlasovsoft_usbnet/dropbear.log 2>&1
fi

insmod $driver_root/arcotg_udc.ko
insmod $driver_root/g_ether.ko host_addr=46:0d:9e:67:69:eb dev_addr=46:0d:9e:67:69:ec
ifconfig usb0 192.168.2.101
test=$?
[ "$KSMdebugmode" == "true" ] && echo "ifconfig usb0 192.168.2.101 exit code: $test" >> $debug_logfile
if [ "$test" -ne "0" ] ; then
  exit
fi



