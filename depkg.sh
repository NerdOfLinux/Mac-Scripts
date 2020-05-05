#!/bin/bash

# This script will install a .pkg file on Mac OS without requiring admin privileges

# Instructions
usage() {
    cat <<EOF
Usage for $0
$0 [-o output] path
EOF
    exit 0;
}

input_file=""

while getopts ":o:" o
do
    case "${o}" in
	o)
	    output_file="$OPTARG"
	    ;;
	*)
	    usage
	    ;;
    esac
done

# Get input file
shift $(($OPTIND - 1))

# If the input file is empty
if [ -z $1 ]
then
    usage
fi

input_file="$1"

# Verify the input file exists
if [ ! -f "$input_file" ]
then
    echo "$input_file doesn not exist"
    exit 1
fi

# Set default output file
if [ -z $output_file ]
then
    output_file=$(basename "$input_file" ".pkg")
    output_file="$HOME/Applications/${output_file}.app"
fi

# Make sure the output file doesn't exist
if [ -e "$output_file" ]
then
    echo "$output_file exists"
    exit 1
fi

# Extract the pkg file
expand_dir=$(mktemp -d)
rmdir "$expand_dir"
echo "Extracting $input_file to $expand_dir"
pkgutil --expand "$input_file" "$expand_dir"

# Check the payload
if [ -f "$expand_dir/Payload" ]
then

fi
possible_pkgs=($expand_dir/*.pkg)
payload_pkg="${possible_pkgs[0]}"
echo "Found $payload_pkg"

payload="$payload_pkg/Payload"

# Create the output file
mkdir "$output_file"

# Check for a payload
if [ -f "$payload" ]
then
    tmp=$(mktemp -d)
    echo "Extracting $payload to $tmp"
    tar xf "$payload" -C "$tmp"
    # Find the .app folder
    possible_apps=($tmp/*.app)
    app_file="${possible_apps[0]}"
    echo "Found $app_file"
    echo "Copying $app_file to $output_file"
    mv $app_file/* $output_file
    # Cleanup
    rm -rf $tmp
elif [ -d "$payload" ]
then
    echo "Renaming payload"
    mv "$payload" "$output_file"
else    
    echo "ERROR! No payload found."
    exit 1
fi
