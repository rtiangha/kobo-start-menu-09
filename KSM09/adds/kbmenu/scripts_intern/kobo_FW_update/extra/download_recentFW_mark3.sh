ksmroot=${ksmroot:-"/adds/kbmenu"}
helpers=$ksmroot/helpers
versionfilename=/mnt/onboard/.kobo/version
currentFWversion="2.6.0"
mark=mark3


echo $($helpers/download_recentFW_update_mark.sh $mark)
