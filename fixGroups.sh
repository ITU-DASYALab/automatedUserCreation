#!/bin/bash
#idea: for x groups/users, fetch pub ssh keys automatically from e.g. a github repo
# to be used at semester start
# SETTINGS to be surced from file settings.conf ###########################
. settings.conf
### has to contain numberOfGroups, repoURL,  homePrefix, namePrefix
###########################################################################

    echo "#########STARTIN - i ll create $numberOfGroups groups #######################################################"

#!/bin/bash
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
    echo "##################### CREATE GROUP $currentGroup"
myHomeDir="$homePrefix""group""$currentGroup"
myTarget="$homePrefix""group""$currentGroup""/.ssh"
############# get the user's key file from repo
# fetch the file
myCurrentFile="$repoURL""group""$currentGroup""/authorized_keys"
 echo "trying to fetch $myCurrentFile "
###### we probably want a tenny weeny little bit of real error checking here ... like, file exists and such ;)
curl -H 'Authorization: token fd528a3de92fbeb79975daf40cff913e6b9cbdce' -H 'Accept: application/vnd.github.v3.raw' -O -L $myCurrentFile 
######### checking whether we downloaded a key file
if [ -e authorized_keys ]
then
    echo "and copying to $myTarget "
    cp authorized_keys $myTarget
else
    echo "could not find key file - ignoring this for now"
fi



rm authorized_keys
 let "currentGroup += 1"

done                     
echo
exit 0

