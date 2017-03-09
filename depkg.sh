#!/bin/bash
echo "Welcome to the depkg shell script. This script will get the .app file out of most .pkg files without the need for admin!"
#If $1 is empty, then ask for the filename of the .pkg file
if [ -z "$1" ]
then
	echo "What .pkg file would you like to depkg?"
	read pkgname
else
	pkgname=$1
fi
#If $2 is empty, then ask for out file
if [ -z "$2" ]
then
    echo "What would you like to name the app?"
    read out
else
    out=$2
fi

#Decompress .pkg file
pkgname="${pkgname//\\}"
pkgutil --expand "${pkgname}" temp.tmp
#Go into folder
cd temp.tmp
#File the app file
payload=$(find . -name "Payload" -size +1000000c)
#If payload is a file
if [ -f "${payload}" ]
then
    #Decompress app
    tar -xzf "${payload}" -C ~/Applications
elif [ -d "${payload}" ]
then
    mkdir ~/Applications/"$out"
    cp -R "${payload}" ~/Applications/"$out".app
fi
cd ..
rm -rf temp.tmp
echo "$out.app is now in your applications folder"
