#!/bin/sh
ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}
###
### user configurable part: begin
###
sourcedir=/etc/wpa_supplicant
sourcefilename=wpa_supplicant.conf
targetfilebasename=wpa_suppl
backupdir=$ksmuser/backup

addtimestamp=true
timestamp=$(date +%y%m%d_%H%M)
#timestamp=$(date +%Y%m%d_%H%M%S)

gzipmode=false
showanimation=false
###
### user configurable part: end
###

source $ksmroot/helpers/backup_helper.sh

