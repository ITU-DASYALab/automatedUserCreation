#!/bin/bash
#idea: remove all users (incl their home dirs) automatically created
# SETTINGS to be surced from file settings.conf ###########################
. settings.conf
### has to contain numberOfGroups, repoURL,  homePrefix, namePrefix
###########################################################################
if [ -e settings.conf ]
then
    echo "found settings"
else
    echo "could not find settings"
    exit 0
fi

currentGroup=1
while [ "$currentGroup" -le "$numberOfGroups" ]
do
 echo "about to delete $currentGroup "
myCurrentName="$namePrefix""$currentGroup"
# add user
userdel -r $myCurrentName
echo " deleted group $currentGroup "
 let "currentGroup += 1"
done                     
echo
exit 0
