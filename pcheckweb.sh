#!/bin/bash
#########################################################################################
#Name    :  physical_ServerHC.sh                                                        #
#Owner   :  root                                                                        #
#Date    :  06-01-2020                                                                  #
#Version :  1                                                                           #
#Author  :  Naveenvk88@gmail.com                                                     #
#Permission : 750                                                                       #
# Shell script to check the physical server status upon the following paramters         #
# 1:Physical Drive.                                                                     #
# 2:Power Cable                                                                         #
# from multiple Linux servers, create dash board and output will copy to a single       #
# server in html format.                                                                #
#########################################################################################
RSSH="/usr/bin/ssh"
RCLOCK="$(date +"%r")"
RHOSTNAME="$(hostname)"

WRITE_HEAD() {
echo '<!DOCTYPE html>
<html>
<head>
<style>
#hosts {
  font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  table-layout: auto;
  width: 40%;
}

#hosts td, #hosts th {
  border: 1px solid #ddd;
  padding: 8px;
}

#hosts th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #4CAF50;
  color: white;
}

#hosts caption {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: center;
  color: white;
}
</style>
</head>
<body>

<table align="center" id="hosts">
  <caption><h3> Physical Servers Health Check Report </h3></caption>
  <tr>
    <th>Host Name</th>
    <th>Disk Drive</th>
    <th>PowerCable</th>
    
   </tr>'
  }

####################################################################################################################################################
################################################# Footer  ##########################################################################################

WRITE_FOOT() {
echo '</table></body></html>'
}

####################################################################################################################################################
################################################# Function Begins ##################################################################################

PHYSICAL_SERVERS_HC() {


SHOSTNAME="$(hostname)"
SCLOCK=$(date +"%F").log
LOGDIR=/tmp/
BAYLOG=$LOGDIR/bayLog-$SCLOCK
SHEALTHY="Healthy"
SFAULTY="Faulty"
#DISK_RETURN
DISK_ACTIVE="OK"
DISK_SPARE="spare"
DISK_YES="YES"
HEALTH_CHECK_LOG=$LOGDIR/health_check-$SCLOCK
POWER_PRESENT_LOG=$LOGDIR/power_present-$SCLOCK
POWER_REDUCNDANT_LOG=$LOGDIR/power_redundant-$SCLOCK
POWER_CONDITION_LOG=$LOGDIR/power_condition-$SCLOCK
POWER_PSTATUS=$LOGDIR/power_pstatus-$SCLOCK
POWER_RSTATUS=$LOGDIR/power_rstatus-$SCLOCK
POWER_CSTATUS=$LOGDIR/power_cstatus-$SCLOCK


####################################################################################################################################################
####################################################################################################################################################

#hostname
echo '<td><font size="3" color="green">'$SHOSTNAME'</font></td>'
#hwDetails=$( cat dmcode |egrep -i "Manufacturer|Product|Serial")
 #               echo '<td><font size="3" color="green">'$hwDetails'</font></td>'

#####################################################################################################################################################
################################################# Physical Drive Checking  ##########################################################################
#echo '<td>'

#testing="$(
physical_drive() {
RETVAL=""
IFS=$'\n ';
bay_Output=$(hpacucli ctrl all show config |grep -i physicaldrive|awk  '{print $5 $6 $NF}'|awk -F ':' '{print $2}'|sed 's/)//g')
echo $bay_Output > $BAYLOG
IFS=$'\n ';
for baynum in `cat $BAYLOG`

#for baynum in `cat diskDrive`
do
val=$(echo $baynum|egrep -i -o "$DISK_ACTIVE|$DISK_SPARE")
       # if [[ "$val" == "$DISK_ACTIVE" ]]
	if [[  ("$val" == "$DISK_ACTIVE" )  || ("$val" == "$DISK_SPARE") ]]
              then

                local DISK_RESULT="HEALTHY" #  $bayNum"
                echo "$DISK_RESULT"
else

               local DISK_RESULT="FAULTY" #  $bayNum"
               echo "$DISK_RESULT"
fi
done

}
####################################################################################################################################################


####################################################################################################################################################
################################################# Power Supply #####################################################################################

power_cable() {
hpasmcli -s " show powersupply"|egrep -i Present >  $POWER_PRESENT_LOG
hpasmcli -s " show powersupply"|egrep -i Redundant > $POWER_REDUCNDANT_LOG
hpasmcli -s " show powersupply"|egrep -i ok >  $POWER_CONDITION_LOG

#cat power_Supply |egrep -i Present > $POWER_PRESENT_LOG
#cat power_Supply |egrep -i Redundant > $POWER_REDUCNDANT_LOG
#cat power_Supply |egrep -i Condition > $POWER_CONDITION_LOG

IFS=$'\n';
#pres_lines = 0;
for powerpresent in `cat $POWER_PRESENT_LOG`
do
        ((pres_lines++))
         echo $powerpresent |grep -i $DISK_YES >> $POWER_PSTATUS
        if [ $? -eq 0 ]
        then

                local POWER_RESULT="HEALTHY"
                echo "$POWER_RESULT"
        else
                local POWER_RESULT="FAULTY"
                echo "$POWER_RESULT"
        fi
done
#red_lines = 0;
for predundant in `cat $POWER_REDUCNDANT_LOG`
        do
                ((red_lines++))
        echo $predundant |grep -i $DISK_YES >> $POWER_RSTATUS
        if  [ $? -eq 0 ]
        then
                local POWER_RESULT="HEALTHY"
               echo "$POWER_RESULT"
        else
                local POWER_RESULT="FAULTY"
                echo "$POWER_RESULT"

        fi

done

#ok_lines = 0;
for pcondition in `cat $POWER_CONDITION_LOG`
        do
         ((ok_lines++))
         echo $pcondition |grep -i $DISK_ACTIVE >> $POWER_CSTATUS
         if  [ $? -eq 0 ]
        then
                local POWER_RESULT="HEALTHY"
                echo "$POWER_RESULT"
        else
                local POWER_RESULT="FAULTY"
               echo  "$POWER_RESULT"
        fi
done
}

#echo '<td>'

ccall_fucntion_main() {

DISK_RESULT=$(physical_drive)
        for diskstatus in "${DISK_RESULT[@]}"
        do
                if [[ " ${diskstatus[@]} " =~ "FAULTY"  ]]
                then
                        echo '<font size="3" color="red">'$SFAULTY'</font>'
                                                #echo -e "$SHOSTNAME    $SFAULTY"  #> $HEALTH_CHECK_LOG
                else
                        echo '<font size="3" color="green">'$SHEALTHY'</font>'
                        #echo -e "$SHOSTNAME    $SHEALTHY"
                fi
        done

}


#echo '</td>'
#echo '<td>'

call_fucntion_main() {
POWER_RESULT=$(power_cable)
#for powerstatus in "${POWER_RESULT[@]}"
        #for diskstatus in "${DISK_RESULT[@]}"
	for powerstatus in "${POWER_RESULT[@]}"
        do
                if [[ " ${powerstatus[@]} " =~ "FAULTY" ]]
                then
                        echo '<font size="3" color="red">'$SFAULTY'</font>'
						#echo -e "$SHOSTNAME    $SFAULTY"  #> $HEALTH_CHECK_LOG
                else
			echo '<font size="3" color="green">'$SHEALTHY'</font>'
                        #echo -e "$SHOSTNAME    $SHEALTHY"
                fi
        done
}

#echo '</td>'
echo '<td>'
ccall_fucntion_main
echo '</td>'
echo '<td>'
call_fucntion_main
echo '</td>'

#echo '<font size="3" color="red">'$mainFunction'</font>'
#mainFunction
#echo '<font size="3" color="red">'$call_fucntion_main'</font>'
#echo '</td>'
}
####################################################################################################################################################

####################################################################################################################################################
################################################# Main Function # ##################################################################################

#Main Function
MAIN() {
MTIME="$(date +"%d-%m-%Y %r")"
#echo 'To: naveen.kulkarni@cenovus.com Rajkumar.Surendran@cenovus.com'
#echo "Subject: Physical Server Health Check Report on $MTIME"
#echo 'Content-Type: text/html'
WRITE_HEAD
#for h in `cat $PWD/hosts`; do
for h in `cat /home/nkulka99/final/hosts`; do
##$PING -c1 $h > /dev/null
$RSSH -q $h "uptime" > /dev/null
if [ "$?" != "0" ] ; then
        echo '<tr>'
        echo '<td bgcolor="red"><font size="3">'$h'</font></td>'
        echo '<td colspan="4"><font size="3" color="red">Server Not Accessible</font></td>'
        echo '</tr>'
else
       echo '<tr>'
    # PHYSICAL_SERVERS_HC
      ssh -q $h "$(typeset -f PHYSICAL_SERVERS_HC); PHYSICAL_SERVERS_HC"
       echo '</tr>'
fi
done
WRITE_FOOT
}
####################################################################################################################################################
################################################# End of Function ##################################################################################

#### END of Functions
OUTFILE="/tmp/hcheck.html"
mytext=$(MAIN)
echo "$mytext" > "$OUTFILE"
exit 0


