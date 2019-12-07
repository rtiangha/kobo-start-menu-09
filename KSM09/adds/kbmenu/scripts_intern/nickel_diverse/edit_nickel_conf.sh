ksmroot=${ksmroot:-"/adds/kbmenu"}
ksmuser=${ksmuser:-"/mnt/onboard/.adds/kbmenu_user"}

$ksmroot/kbconfsel.sh '/mnt/onboard/.kobo/Kobo/Kobo eReader.conf' -optionsfile=$ksmuser/confoptions/nickel_conf_options.txt
