#!/bin/sh

MODULE_LOADED=`lsmod | grep -c g_file_storage`

if [ $MODULE_LOADED -eq 0 ]; then
  exit
fi

/sbin/rmmod g_file_storage
if [ $CPU == mx6sll ] || [ $CPU == mx6ull ]; then
  /sbin/rmmod usb_f_mass_storage
  /sbin/rmmod libcomposite
  /sbin/rmmod configfs
else
  /sbin/rmmod arcotg_udc
fi
sleep 1

PARTITION=/dev/mmcblk0p3
MOUNTARGS="noatime,nodiratime,shortname=mixed,utf8"

FS_CORRUPT=0
dosfsck -a -w $PARTITION || dosfsck -a -w $PARTITION || dosfsck -a -w $PARTITION || dosfsck -a -w $PARTITION || FS_CORRUPT=1
if [ $FS_CORRUPT == 1 ]; then
  echo "Corruption detected on $PARTITION - rebooting..."
  reboot
fi
mount -o $MOUNTARGS -t vfat $PARTITION /mnt/onboard

# ---- Tshering start
if [ $(blkid | grep -c "TYPE=") -gt 0 ]; then
  SD=`blkid | tac | grep -v EFI | grep -v "^/dev/mmcblk0p3" | grep "TYPE=\"vfat\"" | cut -d':' -f1`
else
  SD="/dev/mmcblk1p1"
fi
if [ -e $SD ]; then
  mount -r -t vfat -o $MOUNTARGS $SD /mnt/sd
fi

( sleep 1
rm -rf /mnt/onboard/fsck*
rm -rf /mnt/onboard/FSCK*
) &

