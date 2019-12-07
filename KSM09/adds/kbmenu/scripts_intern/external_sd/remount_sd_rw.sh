#!/bin/sh

answer=$(mount -v -o remount,rw /mnt/sd 2>&1)
case $? in
  0 ) echo "remounted as read-write";;
  * ) echo "$answer";;
esac
