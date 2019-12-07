#!/bin/sh

answer=$(mount -o remount,ro /mnt/sd 2>&1)
case $? in
  0 ) echo "remounted as read-only";;
  * ) echo "$answer";;
esac
