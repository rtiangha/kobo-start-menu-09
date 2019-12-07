#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
frontlightprg=$ksmroot/tools/frontlight
dontTamperwithFrontlight=${dontTamperwithFrontlight:-"true"}


#todo: implement for values: ask_the_user|switch_off|leave_alone
handleWifiBeforeNickel=${handleWifiBeforeNickel:-"switch_off"}
#todo: implement for values: ask_the_user|switch_off|switch_on|leave_alone
handleWifiAfterNickel=${handleWifiAfterNickel:-"switch_off"}

if [ "$KSMdebugmode" == "true" ]; then
  debug_logfile=$ksmroot/log/ksmdebug_$(date +%Y%m%d_%H%M%S)_$(basename $0).log
  echo "started: $(date +%Y%m%d_%H%M%S)" > $debug_logfile
  echo "product: $PRODUCT" >> $debug_logfile
fi

if [ -e /mnt/onboard/.kobo/Kobo.tgz ] || [ -e /mnt/onboard/.kobo/KoboRoot.tgz ]; then
  $ksmroot/kbmessage.sh "Please handle your update files!"
  exit
fi

if [ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ]; then
  case ${handleWifiBeforeNickel} in
    ask_the_user )
      switchoffselection=$($ksmroot/kobomenu.sh -infolines=1 -infotext="Switch_off_wifi?" -autoselectafter="20" -autoselectoption="yes" "yes no")
      case $switchoffselection in
        yes )
          $ksmroot/scripts_intern/wifi/wifi_disable.sh;;
      esac
      ;;
    switch_off )
      $ksmroot/scripts_intern/wifi/wifi_disable.sh;;
  esac
fi

fbgeometry=$(fbset | grep geometry | xargs)
currentRotation=$(cat /sys/class/graphics/fb0/rotate)

$ksmroot/onstart/feedfmon.sh

avoidPickel=${avoidPickel:-"true"}
if [ "$avoidPickel" == "true" ]; then
  animator="$ksmroot/scripts_intern/div/on-animator.sh"
else
  animator="$ksmroot/scripts_intern/replaceoriginal/on-animator.sh"
fi


( usleep 400000; $animator ) &

(

if [ "$avoidPickel" != "true" ]; then
  /usr/local/Kobo/pickel disable.rtc.alarm
fi

if [ ! -e /etc/wpa_supplicant/wpa_supplicant.conf ]; then
  cp /etc/wpa_supplicant/wpa_supplicant.conf.template /etc/wpa_supplicant/wpa_supplicant.conf
fi



#echo 1 > /sys/devices/platform/mxc_dvfs_core.0/enable

#/sbin/hwclock -s -u
) &

# frontligth off
[ "$dontTamperwithFrontlight" == "true" ] && [ "$PRODUCT" != "trilogy" ] && [ "$PRODUCT" != "pixie" ] &&
(
$frontlightprg "0"
[ "$KSMdebugmode" == "true" ] && echo "on start: frontlight level set to 0" >> $debug_logfile
)

export NICKEL_HOME=/mnt/onboard/.kobo
export LD_LIBRARY_PATH=/usr/local/Kobo
if [ "nickelpreload" != "" ]; then
  export LD_PRELOAD="$nickelpreload"
fi

start_again="true"
while [ "${start_again}" == "true" ]
do
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
# [ $PLATFORM != freescale ] && rm -rf /dev/mmcblk1* && udevadm trigger &
    /usr/local/Kobo/nickel -qws -skipFontLoad
  else
    /usr/local/Kobo/hindenburg &
#   insmod /drivers/$PLATFORM/misc/lowmem.ko &
    lsmod | grep -q lowmem || insmod /drivers/$PLATFORM/misc/lowmem.ko &
#  [ `cat /mnt/onboard/.kobo/Kobo/Kobo\ eReader.conf | grep -c dhcpcd=true` == 1 ] && dhcpcd -d -t 10 &
    /usr/local/Kobo/nickel -platform kobo -skipFontLoad
  fi
  sleep 2
  if [ "x$(pidof fmon)" == "x" ] || [ -e /mnt/onboard/.kobo/Kobo.tgz ] || [ -e /mnt/onboard/.kobo/KoboRoot.tgz ]; then
    start_again="false"
  fi
#disable start_again until I find a safer way to do it
  start_again="false"
  if [ "${start_again}" == "true" ] && [ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ]; then
    ${ksmroot}/scripts_intern/wifi/wifi_disable.sh
  fi
done

if [ "$currentRotation" != "$(cat /sys/class/graphics/fb0/rotate)" ]; then
  echo "$currentRotation" > /sys/class/graphics/fb0/rotate
  cat /sys/class/graphics/fb0/rotate > /sys/class/graphics/fb0/rotate
fi

fbset -${fbgeometry}
if [ "$currentRotation" != "$(cat /sys/class/graphics/fb0/rotate)" ]; then
  cat /sys/class/graphics/fb0/rotate > /sys/class/graphics/fb0/rotate
fi

#set frontlight for KSM
[ $PRODUCT != trilogy ] && [ $PRODUCT != pixie ] && [ $PRODUCT != pika ] && (
$frontlightprg "$KSMfrontlightlevel"
[ "$KSMdebugmode" == "true" ] && echo "before exit: frontlight level set to $KSMfrontlightlevel" >> $debug_logfile
)

if [ "${handleWifiAfterNickel}" != "leave_alone" ]; then
  if [ $(lsmod | grep -c sdio_wifi_pwr) -gt 0 ]; then
    case ${handleWifiAfterNickel} in
      ask_the_user )
        switchoffselection=$($ksmroot/kobomenu.sh -infolines=1 -infotext="Switch_off_wifi?" "yes no")
        case $switchoffselection in
          yes )
            $ksmroot/scripts_intern/wifi/wifi_disable.sh;;
        esac
        ;;
      switch_off )
        $ksmroot/scripts_intern/wifi/wifi_disable.sh;;
    esac
  else
    case ${handleWifiAfterNickel} in
      switch_on )
        $ksmroot/scripts_intern/wifi/wifi_enable_dhcp.sh;;
    esac
  fi
fi

killall fmon
