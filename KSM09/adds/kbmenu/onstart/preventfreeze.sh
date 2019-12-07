#!/bin/sh

[ "$(pidof $(basename $0) | wc -w)" -gt "2" ] && exit

while :
do
  sleep 1
done
