#!/bin/bash
##############################################################################
### Script to half-automate user creation, a lot faster than manual work
### but leaving a few things deliberately manual, e.g. setting password
##############################################################################
echo  "======================================================================" 
echo  "Create a user with normal user rights" 
echo  "======================================================================" 
echo  "enter the username:" 
read -p "type here: " username
echo "##################### CREATE USER $username with"
myHomeDir="/home/""$username"
############ create user, unless i already have that user
if [ -d $myHomeDir ]
then
	echo  "======================================================================" 
    echo "WARNING user exists! no problem. you may still add a new pub key."
	echo  "======================================================================" 
else
    echo "creating user $username "
    useradd -m $username
fi
mkdir $myHomeDir"/.ssh"
echo  "======================================================================" 
echo  "PubKey" 
echo  "======================================================================" 
read -p "type/paste here: " pubkey
echo "$pubkey" > "$myHomeDir""/.ssh/authorized_keys"
chown -R $username:$username $myHomeDir
echo  "======================================================================" 
echo  "Password" 
echo  "======================================================================" 
passwd $username
exit 0
