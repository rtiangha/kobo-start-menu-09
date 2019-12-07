#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}
###
### user configurable part: begin
###
sourcedir=/mnt/onboard/.kobo
sourcefilename=KoboReader.sqlite
targetfilebasename=KR.sql
backupdir=$ksmuser/backup

addtimestamp=true
timestamp=$(date +%y%m%d_%H%M)
#timestamp=$(date +%Y%m%d_%H%M%S)

gzipmode=true
showanimation=true
###
### user configurable part: end
###

source $ksmroot/helpers/backup_helper.sh
