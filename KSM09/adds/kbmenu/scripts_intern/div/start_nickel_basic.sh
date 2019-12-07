#!/bin/sh
#simply start nickel, do not care about light, rotation, fb settings, fmon

ksmroot=${ksmroot:-"/adds/kbmenu"}
animator="${ksmroot}/scripts_intern/replaceoriginal/on-animator.sh"

useFmon=${useFmon:-"false"}
if [ ${useFmon} == "true" ]; then
  ${ksmroot}/onstart/feedfmon.sh
fi

letWifiOn=${letWifiOn:-"false"}
enableWifiAfterwards="false"
if [ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ]; then
  if [ ${letWifiOn} == "false" ]; then
    ${ksmroot}/scripts_intern/wifi/wifi_disable.sh
    enableWifiAfterwards="true"
  fi
fi

( usleep 400000; ${animator} ) &
(
/usr/local/Kobo/pickel disable.rtc.alarm
if [ ! -e /etc/wpa_supplicant/wpa_supplicant.conf ]; then
  cp /etc/wpa_supplicant/wpa_supplicant.conf.template /etc/wpa_supplicant/wpa_supplicant.conf
fi
) &

export NICKEL_HOME=/mnt/onboard/.kobo
export LD_LIBRARY_PATH=/usr/local/Kobo

grep -qs '/mnt/sd' /proc/mounts && echo sd add /dev/mmcblk1p1 >> /tmp/nickel-hardware-status &

if [ ! -e /usr/local/Kobo/platforms/libkobo.so ]; then
  export QWS_KEYBOARD=imx508kbd:/dev/input/event0
  export QT_PLUGIN_PATH=/usr/local/Kobo/plugins
  if [ -e /usr/local/Kobo/plugins/gfxdrivers/libimxepd.so ]; then
    export QWS_DISPLAY=imxepd
  else
    export QWS_DISPLAY=Transformed:imx508:Rot90
    export QWS_MOUSE_PROTO="tslib_nocal:/dev/input/event1"
  fi
  /usr/local/Kobo/hindenburg &
# [ ${PLATFORM} != freescale ] && rm -rf /dev/mmcblk1* && udevadm trigger &
  /usr/local/Kobo/nickel -qws -skipFontLoad
else
  /usr/local/Kobo/hindenburg &
#   insmod /drivers/${PLATFORM}/misc/lowmem.ko &
  lsmod | grep -q lowmem || insmod /drivers/${PLATFORM}/misc/lowmem.ko &
#  [ `cat /mnt/onboard/.kobo/Kobo/Kobo\ eReader.conf | grep -c dhcpcd=true` == 1 ] && dhcpcd -d -t 10 &
  /usr/local/Kobo/nickel -platform kobo -skipFontLoad
fi

if [ ${enableWifiAfterwards} == "true" ] && [ $(lsmod | grep -c sdio_wifi_pwr) -eq 0 ]; then
  ${ksmroot}/scripts_intern/wifi/wifi_enable_dhcp.sh
fi




