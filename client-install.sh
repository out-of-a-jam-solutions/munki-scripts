#! /bin/bash

#################
### ARGUMENTS ###
#################
# 1) munki repository URL, ex. http://10.0.1.1/munki_repo

# environment
SERVER_HOST="$1"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"  # https://stackoverflow.com/questions/59895/get-the-source-directory-of-a-bash-script-from-within-the-script-itself

# install munki tools
echo "installing latest munki release"
curl -L `curl -s https://api.github.com/repos/munki/munki/releases/latest | grep browser_download_url | cut -d '"' -f 4` -o $DIR/munki.pkg
sudo installer -pkg $DIR/munki.pkg -target /

# install munki conditional scripts
echo "installing latest conditional scripts release"
curl -L `curl -s https://api.github.com/repos/out-of-a-jam-solutions/munki-conditions-pkg/releases/latest | grep browser_download_url | cut -d '"' -f 4` -o $DIR/conditional-scripts.pkg
sudo installer -pkg $DIR/conditional-scripts.pkg -target /

# write the munki repo URL
echo "Setting ManagedInstalls preference"
sudo defaults write /Library/Preferences/ManagedInstalls SoftwareRepoURL $SERVER_HOST

# create the munki bootstrap file
echo "creating bootstrap file"
touch /Users/Shared/.com.googlecode.munki.checkandinstallatstartup

# restart the computer
echo "restarting..."
sudo shutdown -r now
