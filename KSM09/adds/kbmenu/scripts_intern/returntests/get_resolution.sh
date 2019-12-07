#!/bin/sh

RES=`ntx_hwconfig -s -p /dev/mmcblk0 DisplayResolution`

echo "resolution: $RES"
