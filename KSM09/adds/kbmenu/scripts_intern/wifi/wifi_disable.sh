#!/bin/sh

wlarm_le -i eth0 down
ifconfig eth0 down
/sbin/rmmod -r ${WIFI_MODULE}
/sbin/rmmod -r sdio_wifi_pwr

killall udhcpc default.script wpa_supplicant dhcpcd-dbus dhcpcd 2>/dev/null

