#!/bin/sh

PLATFORM=freescale
if [ `dd if=/dev/mmcblk0 bs=512 skip=1024 count=1 | grep -c "HW CONFIG"` == 1 ]; then
	CPU=`ntx_hwconfig -s -p /dev/mmcblk0 CPU`
	PLATFORM=$CPU-ntx
fi

if [ $CPU ]; then
        PCB=`ntx_hwconfig -s -p /dev/mmcblk0 PCB`
        RAM=`ntx_hwconfig -s -p /dev/mmcblk0 RAMType`
	RAM_SIZE=`ntx_hwconfig -s -p /dev/mmcblk0 RamSize`
	RAM_SIZE=`echo $RAM_SIZE | awk '{print $RAM_SIZE-MB}'`
        NEW_UBOOT=/mnt/onboard/.kobo/upgrade/$PLATFORM/u-boot_mddr_$RAM_SIZE-$PCB-$RAM.bin
        NEW_KERNEL=/mnt/onboard/.kobo/upgrade/$PLATFORM/uImage-$PCB
        [ ! -e NEW_UBOOT] && NEW_UBOOT=/mnt/onboard/.kobo/upgrade/$PLATFORM/u-boot_lpddr2_$RAM_SIZE-$PCB-$RAM.bin
	[ -e $NEW_UBOOT ] && UBOOT=$NEW_UBOOT
	[ -e $NEW_KERNEL ] && KERNEL=$NEW_KERNEL
fi

if [ ! -e  /etc/u-boot/$PLATFORM/u-boot.mmc ];then
INFO="rather ntx508"
else
INFO="seems ok"
fi
echo "cpu: $CPU<br> platform: $PLATFORM<br> pcb: $PCB<br> ramsize: $RAM_SIZE<br> ramtype: $RAM<br> info: $INFO "
