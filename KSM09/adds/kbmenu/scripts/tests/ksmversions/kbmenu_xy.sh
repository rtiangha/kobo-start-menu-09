#You can run further instances of KSM for test purposes
#This example supposes that the folder "kbmenu_xy" (containing the "system part" of KSM) is in /adds.
export ksmroot=/adds/kbmenu_test_xy

#This example supposes that the folder "kbmenu_xy_user" (containing the "user part" of KSM) is in (/mnt/onboard/).adds.
export ksmuser=/mnt/onboard/.adds/kbmenu_xy_user

sh $ksmroot/onstart/ksmhome.sh
