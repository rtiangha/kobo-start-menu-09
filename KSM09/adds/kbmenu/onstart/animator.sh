#!/bin/sh

ksmroot=${ksmroot:-"/adds/kbmenu"}
imgprg=$ksmroot/kbmessage.sh
imgpath=$ksmroot/images
i=0;
while true; do
        i=$((((i + 1)) % 4));
        sh $imgprg "<img src='$imgpath/man$i.png' alt='xxx' width='400' height='400'>" &
        usleep 250000;
        killall kbmessage
killall kobomessage
done 
