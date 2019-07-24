#! /bin/bash

#################
### ARGUMENTS ###
#################
# 1) munki installer package existing in the same directory as the install script, ex. munkitools-3.6.2.3776.pkg
# 2) munki repository URL, ex. http://10.0.1.1/munki_repo

# environment
MUNKI_PKG=$1
SERVER_HOST="$2"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"  # https://stackoverflow.com/questions/59895/get-the-source-directory-of-a-bash-script-from-within-the-script-itself

# install munki tools
echo "installing $MUNKI_PKG"
sudo installer -pkg $DIR/$MUNKI_PKG -target /

# write the munki repo URL
echo "Setting ManagedInstalls preference"
sudo defaults write /Library/Preferences/ManagedInstalls SoftwareRepoURL $SERVER_HOST

# show changed ManagedInstalls
echo "ManagedInstalls preference is:"
sudo defaults read /Library/Preferences/ManagedInstalls

# copy the conditional install scripts
sudo mkdir /usr/local/munki/conditions
sudo cp $DIR/check-10.13-highsierra-compatibility.py /usr/local/munki/conditions/check-10.13-highsierra-compatibility.py
sudo cp $DIR/check-10.14-mojave-compatibility.py /usr/local/munki/conditions/check-10.14-mojave-compatibility.py

# set the conditional script permissions
sudo chown root:wheel /usr/local/munki/conditions/*
sudo chmod +x /usr/local/munki/conditions/*

# create the munki bootstrap file
touch /Users/Shared/.com.googlecode.munki.checkandinstallatstartup

# sleep for 5 seconds
echo "restarting in 5 seconds..."
sleep 5

# restart the computer
sudo shutdown -r now
