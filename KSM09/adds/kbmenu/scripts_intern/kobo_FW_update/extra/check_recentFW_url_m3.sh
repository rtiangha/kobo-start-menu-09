ksmroot=${ksmroot:-"/adds/kbmenu"}
helpers=$ksmroot/helpers
versionfilename=/mnt/onboard/.kobo/version
mark="mark3"
currentFWversion="2.6.1"

echo $($helpers/get_FW_update_url_mark.sh $mark $currentFWversion)
