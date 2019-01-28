#!/bin/bash
#idea: for x users defined by cmd line input, fetch pub ssh keys automatically from e.g. a github repo
# to be used at semester start
# SETTINGS to be surced from file settingsDS.conf ###########################
. settingsDS.conf
### has to contain repoURL,  homePrefix, namePrefix
###########################################################################

    echo "#########STARTIN - i ll create $numberOfGroups groups #######################################################"

#!/bin/bash
if [ -e settingsDS.conf ]
then
    echo "found settings"
else
    echo "could not find settings"
    exit 0
fi
echo  "Enter just the number of the users separated by 'space', like this: 1 5 13 29" 
read -p "type here: " input
for i in ${input[@]}

##################################################################
do
    echo "##################### CREATE USER $i"
myHomeDir="$homePrefix""$namePrefix""$i"

############ create user, unless i already have that user
if [ -d $myHomeDir ]
then
    echo "WARNING user exists! no problem"
else
    echo "creating user $i "
    myCurrentName="$namePrefix""$i"
    # add user
    useradd -m $myCurrentName
fi

############# get the user's key file from repo
# fetch the file
myCurrentFile="$repoURL""$namePrefix""$i"".pub?token=AAAAJm7jpokrZO7njCvfNv5jiyQ-JpB-ks5cVv3MwA%3D%3D"
myTempFile="$namePrefix""$i"".pub?token=AAAAJm7jpokrZO7njCvfNv5jiyQ-JpB-ks5cVv3MwA%3D%3D"
 echo "trying to fetch $myCurrentFile "
#wget $myCurrentFile
wget $myCurrentFile
######### checking whether we downloaded a key file
if [ -e $myTempFile ]
then
mv $myTempFile authorized_keys
    echo "ok, found they key file and will transfer"
    myTarget="$homePrefix""$namePrefix""$i""/.ssh"

        if [ -d $myTarget ]
        then
                echo "directory exists, nothing to do, no problem"
                else
                        echo "creating directory - "
                        echo $myTarget
                    mkdir $myTarget
        fi

    echo "and copying to $myTarget "
    cp authorized_keys $myTarget
else
    echo "could not find key file - ignoring this for now. we can fetch that later"
fi

echo "chowning the home dir to the new user $myCurrentName"
chown -R $myCurrentName:$myCurrentName $myHomeDir

rm authorized_keys
#################################################################3
echo ""
done
         
echo
exit 0
