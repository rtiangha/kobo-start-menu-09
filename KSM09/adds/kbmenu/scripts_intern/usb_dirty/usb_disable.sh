#!/bin/sh

MODULE_LOADED=`lsmod | grep -c g_file_storage`



DEV="/dev/mmcblk1p1"

	if [ $MODULE_LOADED -eq 0 ]; then
		exit
	fi

	/sbin/rmmod g_file_storage
	/sbin/rmmod arcotg_udc
	sleep 1

	if [ -e /drivers/$PLATFORM ]; then
		PARTITION=/dev/mmcblk0p3
		MOUNTARGS="noatime,nodiratime,shortname=mixed,utf8"
	fi

#	dosfsck -a -w $PARTITION
#	mount -o $MOUNTARGS -t vfat $PARTITION /mnt/onboard

	if [ -e $DEV ]; then
		mount -r -t vfat -o $MOUNTARGS $DEV /mnt/sd
	fi

#	( sleep 1
#		rm -rf /mnt/onboard/fsck*
#		rm -rf /mnt/onboard/FSCK*
#	) &

