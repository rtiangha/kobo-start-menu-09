ksmroot=${ksmroot:-"/adds/kbmenu"}
helpers=$ksmroot/helpers
versionfilename=/mnt/onboard/.kobo/version
mark="mark4"

if [ -e $versionfilename ]; then
  currentFWversion=$(awk -F"," '{print $3}' $versionfilename)
else
  echo "failed_to_find_current_FW_version"
  exit
fi


echo $($helpers/get_FW_update_url_mark.sh $mark $currentFWversion)
