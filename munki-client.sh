#! /bin/bash

# environment
MUNKI_PKG=munkitools-VERSION.pkg
SERVER_HOST="http://IP_ADDRESS/munki_repo"
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

# sleep for 5 seconds
echo "restarting in 10 seconds..."
sleep 5

# restart the computer
sudo shutdown -r now
