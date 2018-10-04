#!/bin/bash
#idea: remove all users (incl their home dirs) automatically created
# SETTINGS to be sourced from file settings.conf ###########################
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
# delete user
userdel -r $myCurrentName

# delete hdfs user
echo "currentGroup=""$currentGroup" >> settings.conf
su hdfs << 'EOF'
. settings.conf
myCurrentName="$namePrefix""$currentGroup"
hdfs dfs -rm -r "/user/""$myCurrentName"
hdfs dfs -rm -r "/tmp/hadoop-""$myCurrentName"
EOF
sed -i '$d' settings.conf

echo " deleted group $currentGroup "
 let "currentGroup += 1"
done
echo
exit 0
