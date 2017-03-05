#!/bin/bash
echo "Welcome to the no admin mac installer."
#If $1 is empty
if [ -z "$1" ]
then
    echo "Where is the application you would like to install?"
    read location
else
    location=$1
fi

#If $2 is empty
if [ -z "$2" ]
then
    echo "What would you like the app name to be?"
    read out
else
    out=$2
fi
#Take backslashes out of file name
location="${location//\\}"
out="${out//\\}"
#Make folder
mkdir ~/Applications/"${out}".app
#Go into .app file
cd "${location}"
cp -R Contents ~/Applications/"${out}".app/Contents
