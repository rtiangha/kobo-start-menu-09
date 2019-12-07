#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}

. $ksmroot/onstart/exp_block

if [ "$mrotation" == "0" ] || [ "$mrotation" == "180" ]; then
   thewidth=$ksmImageWidthLandscape
else
   thewidth=$ksmImageWidthPortrait
fi


imgprg=$ksmroot/kbmessage
$imgprg "<img src=\"$1\"  width='$thewidth' />" -qws
