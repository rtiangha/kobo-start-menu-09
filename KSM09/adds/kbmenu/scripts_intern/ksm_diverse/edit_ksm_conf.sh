ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

$ksmroot/kbconfsel.sh $ksmroot/ksm_ini -optionsfile=$ksmuser/confoptions/ksm_ini_options.txt
