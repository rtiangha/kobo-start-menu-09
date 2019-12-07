#!/bin/sh

##purpose find files in .pdfs of the user partition and open one in koreader

ksmroot=${ksmroot:-"/adds/kbmenu"}
$ksmroot/helpers/open_book_in_koreader.sh "/mnt/onboard/.pdfs"
