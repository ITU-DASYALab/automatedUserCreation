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
myHomeDir="$homePrefix""$namePrefix""$currentGroup"

############ create user, unless i already have that user
if [ -d $myHomeDir ]
then
    echo "User already exists"
else
    echo "creating group $currentGroup "
    myCurrentName="$namePrefix""$currentGroup"
    # add user
    useradd -m $myCurrentName
    ######## Access to Spark and Kafka easier
    echo "Updating users .bashrc"
    echo "alias spark-shell='SPARK_MAJOR_VERSION=2 spark-shell'" >> "$homePrefix""$namePrefix""$currentGroup""/.bashrc"
    echo "alias spark-submit='SPARK_MAJOR_VERSION=2 spark-submit'" >> "$homePrefix""$namePrefix""$currentGroup""/.bashrc"
    echo "alias kafka-topics='/usr/hdp/current/kafka-broker/bin/kafka-topics.sh'" >> "$homePrefix""$namePrefix""$currentGroup""/.bashrc"

    ######## Create user in hdfs
    echo "Switching to hdfs user"
    echo "currentGroup=""$currentGroup" >> settings.conf
su hdfs << 'EOF'
    . settings.conf
    myCurrentName="$namePrefix""$currentGroup"
    echo $myCurrentName
    hdfs dfs -mkdir "/user/""$myCurrentName"
    hdfs dfs -chown -R "$myCurrentName"":""$myCurrentName" "/user/""$myCurrentName"
    hdfs dfs -mkdir "/tmp/hadoop-""$myCurrentName"
    hdfs dfs -chmod -R 777 "/tmp/hadoop-""$myCurrentName"
EOF

    ######### Data Link
    ln -s /home/dataextractor/files/data/ "$myHomeDir""/wifi_data"

fi

############# get the user's key file from repo
# fetch the file
myCurrentFile="$repoURL""$namePrefix""$currentGroup""/authorized_keys"
 echo "trying to fetch $myCurrentFile "
###### we probably want a tenny weeny little bit of real error checking here ... like, file exists and such ;)
wget $myCurrentFile
mv "./authorized_keys" "./authorized_keys"
######### checking whether we downloaded a key file
if [ -e authorized_keys ]
then
    echo "ok, found key file and will transfer"
    myTarget="$homePrefix""$namePrefix""$currentGroup""/.ssh"

        if [ -d $myTarget ]
        then
                echo "directory exists, nothing to do"
                else
                        echo "creating directory - "
                        echo $myTarget
                    mkdir $myTarget
        fi

    echo "and copying to $myTarget "
    cp authorized_keys $myTarget
else
    echo "could not find key file - ignoring this for now"
fi

sed -i '$d' settings.conf

echo "chowning the home dir"
chown -R $myCurrentName:$myCurrentName $myHomeDir


rm authorized_keys
 let "currentGroup += 1"
done
echo
su hdfs << 'EOF'
hdfs dfsadmin -refreshUserToGroupsMappings
EOF
exit 0
