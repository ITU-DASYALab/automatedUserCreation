#!/bin/bash
#idea: remove all users (incl their home dirs) automatically created
# SETTINGS ################################################################
currentGroup=1
numberOfGroups=3
homePrefix="/home/"
namePrefix="group"
###########################################################################

while [ "$currentGroup" -le "$numberOfGroups" ]
do
 echo "about to delete $currentGroup "
myCurrentName="group""$currentGroup"
# add user
userdel -r $myCurrentName
echo " deleted group $currentGroup "
 let "currentGroup += 1"
done                     
echo
exit 0
