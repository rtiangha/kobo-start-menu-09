#!/bin/sh
# source: KoboLauchner
ksmroot=${ksmroot:-"/adds/kbmenu"}
frontlightprg=$ksmroot/tools/frontlight

export PATH=$PATH:/sbin:/usr/sbin

[ $PRODUCT != trilogy ] && [ $PRODUCT != pixie ] && $frontlightprg "0"

# disable wifi
if lsmod | grep -q sdio_wifi_pwr ; then 
	wlarm_le -i eth0 down
	ifconfig eth0 down
	/sbin/rmmod -r dhd
	/sbin/rmmod -r sdio_wifi_pwr
fi

# go to sleep
sync
echo 1 > /sys/power/state-extended
sleep 2s # for aura
echo mem > /sys/power/state
