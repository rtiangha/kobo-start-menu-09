#!/bin/sh

[ ${WIFI_MODULE} = 8189fs ] || [ ${WIFI_MODULE} = 8189es ] || wlarm_le -i ${INTERFACE} down
ifconfig ${INTERFACE} down
/sbin/rmmod -r ${WIFI_MODULE}
/sbin/rmmod -r sdio_wifi_pwr

killall udhcpc default.script wpa_supplicant dhcpcd-dbus dhcpcd 2>/dev/null

