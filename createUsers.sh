#!/bin/bash

if [ -n "$1" ]
then
    if [ -e "$1" ]
    then
        echo "Reading settings"
        . $1
    else
        echo "Could not find settings file!"
        exit 0
    fi
else

    echo "Specify number of users:"
    read numberOfUsers
    echo "numberOfUsers: $numberOfUsers"

    if [ $numberOfUsers -eq 1 ]
    then
        echo "Specify username:"
        read username
        echo "username: $username"
    else
        echo "Specify user prefix [user]:"
        read userPrefix

        if [ -z $userPrefix ]
        then
            userPrefix="user"
        fi
        echo "userPrefix: $userPrefix"
    fi

    echo "Specify home directory location [/home/]:"
    read homePrefix

    if [ -z $homePrefix ]
    then
        homePrefix="/home/"
    fi
    echo "homePrefix: $homePrefix"

    echo "Add authorized_keys file for ssh? [y/n]:"
    read sshAuth

    if [ -z $sshAuth ]
    then
        sshAuth="y"
    fi
    echo "sshAuth: $sshAuth"

    if [ $sshAuth == "y" ]
    then
        echo "Local or external location of file? [l/e]:"
        read localOrExternal
        echo "localOrExternal: $localOrExternal"

        if [ $localOrExternal == "e" ]
        then
            echo "Git [y/n]:"
            read git

            if [ -z $git ]
            then
                git="y"
            fi
            echo "git: $git"

            if [ $git == "y" ]
            then
                echo "Enterprise [y/n]:"
                read enterprise

                if [ -z $enterprise ]
                then
                    enterprise="y"
                fi
                echo "enterprise: $enterprise"

                if [ $enterprise == "y" ]
                then
                    echo "Specify repository API URL (https://github.itu.dk/api/v3/repos/<gitUser>/<repo>/contents/):"
                    read repoURL
                    echo "repoURL: $repoURL"

                    if [ -z $repoURL ]
                    then
                        echo "No URL specified!"
                        exit 0
                    fi

                    echo "Specify personal access token"
                    read token
                    echo "token: $token"

                    if [ -z $token ]
                    then
                        echo "No token specified"
                        exit 0
                    fi
                elif [ $enterprise == "n" ]
                then
                    echo "Specify repository URL (https://raw.githubusercontent.com/<gitUser|group>/<repo>/master/):"
                    read repoURL
                    echo "repoURL: $repoURL"

                    if [ -z $repoURL ]
                    then
                        echo "No URL specified!"
                        exit 0
                    fi
                fi
            else
                echo "Specify external URL:"
                read authURL
                echo "authURL: $authURL"

                if [ -z $authURL ]
                then
                    echo "No URL specified!"
                    exit 0
                fi
            fi
        elif [ $localOrExternal == "l" ]
        then
            echo "Specify path to authorized_keys file:"
            read authPath
            echo "authPath: $authPath"

            if [ -z $authPath ]
            then
                echo "No path specified!"
                exit 0
            fi
        else
            echo "Not a valid command!"
            exit 0
        fi
    fi

    echo "Specify file with commands for users .bashrc (Optional):"
    read bashrcCommands
    echo "bashrcCommands: $bashrcCommands"
fi

u=1

echo "Creating users..."
while [ "$u" -le "$numberOfUsers" ]
do
    if [ $numberOfUsers -ne 1 ]
    then
        username="$userPrefix$u"
    fi

    echo "Creating User $username..."
    homeDir="$homePrefix$username"

    if [ -d $homeDir ]
    then
        echo "User already exists"
    else
        # add user
        useradd -m $username

        if [ -n "$bashrcCommands" ]
        then
            while IFS= read -r line
            do
                echo $line >> "$homeDir/.bashrc"
            done < $bashrcCommands
        fi

        echo "User created!"
    fi

    if [ $sshAuth != "n" ]
    then
        sshDir="$homePrefix$username/.ssh"

        if [ -d $sshDir ]
        then
            echo "Directory $sshDir already exists"
        else
            echo "Creating directory $sshDir"
            mkdir $sshDir
        fi

        if [ $localOrExternal == "e" ]
        then

            echo "Getting authorized_keys file"
            if [[ $git == "y" && $enterprise == "y" ]]
            then
                curl -H "Authorization: token $token" -H "Accept: application/vnd.github.v3.raw" -O -L "$repoURL$username/authorized_keys"
            elif [ $git == "y" ]
            then
                wget "$repoURL$username/authorized_keys"
            else
                wget $authURL
            fi

            echo "Moving authorized_keys to $sshDir"
            if [ -e authorized_keys ]
            then
                mv authorized_keys $sshDir
            else
                echo "authorized_keys not found!"
            fi
        elif [ $localOrExternal == "l" ]
        then
            echo "Copying authorized_keys file from $autPath to $sshDir"
            cp $authPath $sshDir
        fi
    fi

    echo "Setting ownership of user directories"
    chown -R $username:$username $homeDir
    let "u += 1"
done

exit 0
