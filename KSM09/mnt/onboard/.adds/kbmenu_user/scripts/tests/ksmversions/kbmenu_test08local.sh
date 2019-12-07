#You can run further instances of KSM for test purposes
#The following example supposes that the folder "kbmenu_08test" with its complete content is in .adds.
#In this example those files of KSM that normally would be located on the system partiton are located on the user partition for easier access.
#Be aware that this has an effect on unmounting the user partition!
export ksmroot=/mnt/onboard/.adds/kbmenu_08test

#If you want to have the ksmroot part actually on the system partition, the starting script must also be located on the system partiton.

#In this example the new instance of KSM shares the "user part" of the calling KSM instance.
#You can make the new instance use another "user part", e.g: 
#export ksmuser=/mnt/onboard/.adds/kbmenu_08test_user

sh $ksmroot/onstart/ksmhome.sh
