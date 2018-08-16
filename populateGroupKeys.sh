#!/bin/bash
#idea: for x groups/users, fetch pub ssh keys automatically from e.g. a github repo
# to be used at semester start
# SETTINGS ################################################################
currentGroup=1
numberOfGroups=3
repoURL="https://raw.githubusercontent.com/ITU-PITLab/groupTest/master/" 
homePrefix="/home/"
namePrefix="group"
###########################################################################

while [ "$currentGroup" -lt "$numberOfGroups" ]
do
 echo "creating group $currentGroup "
myCurrentName="$namePrefix""$currentGroup"
# add user
useradd -m $myCurrentName
# fetch the file
myCurrentFile="$repoURL""group""$currentGroup""/authorized_keys"
 echo "fetching file $myCurrentFile "
###### we probably want a tenny weeny little bit of error checking here ... like, file exists and such ;)
wget $myCurrentFile
myTarget="$homePrefix""group""$currentGroup"
echo "and copying to $myTarget "
cp authorized_keys $myTarget
 let "currentGroup += 1"

done                     
echo
exit 0
