#!/bin/sh

source $ksmroot/onstart/exp_block
export QWS_DISPLAY=Transformed:KoboFB:Rot90

echo $($ksmroot/kbterminal/kbterminal -qws -geometry 400x600+0+50)
