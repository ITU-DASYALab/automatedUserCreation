#!/bin/bash
#idea: remove all users (incl their home dirs) automatically created
if [ -e settings.conf ]
then
    echo "found settings"
else
    echo "could not find settings"
    exit 0
fi


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
