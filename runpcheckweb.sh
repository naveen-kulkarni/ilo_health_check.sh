#!/bin/bash
sh -x /home/naveen/final/pcheckweb.sh 2> /dev/null

mutt -e "my_hdr Content-Type: text/html" naveenvk88@gmail.com -s "Physical Servers Health Check Report -$(date +"%F")" < /tmp/hcheck.html

