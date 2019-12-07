#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}



# --- change as you see fit (begin)

PRODUCT_ID=${PRODUCT_ID:-"0x4163"}
VERSION=0.0.0
SN=N000000000000
# --- change as you see fit (end)

VENDOR_ID=0x2237

MODULE_LOADED=`lsmod | grep -c g_file_storage`

if [ $(blkid | grep -c "TYPE=") -gt 0 ]; then
  LUNS=`blkid | tac | grep -v EFI | grep "TYPE=\"vfat\"" | cut -d':' -f1 | xargs | sed -e 's/ /,/'`
else
  if [ -e /dev/mmcblk1p1 ]; then
    LUNS=/dev/mmcblk0p3,/dev/mmcblk1p1
  else
    LUNS=/dev/mmcblk0p3
  fi
fi

sync
echo 3 > /proc/sys/vm/drop_caches
umount -l /mnt/onboard
umount -l /mnt/sd


  if [ $CPU == mx6sll ] || [ $CPU == mx6ull ]; then
    PARAMS="idVendor=$VENDOR_ID idProduct=$PRODUCT_ID iManufacturer=Kobo iProduct=eReader-$VERSION iSerialNumber=$SN"
    /sbin/insmod /drivers/$PLATFORM/usb/gadget/configfs.ko
    /sbin/insmod /drivers/$PLATFORM/usb/gadget/libcomposite.ko
    /sbin/insmod /drivers/$PLATFORM/usb/gadget/usb_f_mass_storage.ko
  else
    PARAMS="vendor=$VENDOR_ID product=$PRODUCT_ID vendor_id=Kobo product_id=eReader-$VERSION SN=$SN"
    /sbin/insmod /drivers/$PLATFORM/usb/gadget/arcotg_udc.ko
    sleep 2
  fi


/sbin/insmod /drivers/$PLATFORM/usb/gadget/g_file_storage.ko file=$LUNS stall=1 removable=1 $PARAMS
sleep 1
