#!/bin/bash

echo 'Enter directory'
read directory

if [ ! -d $directory ]; then
        echo 'Incorrect input'
        exit 1
fi

ans=$(find ${directory}  -type d 2>/dev/null | wc -l)
ans1=$(find ${directory}  -type f 2>/dev/null | wc -l)
echo "Number of directories : ${ans}"
echo "Number of files :${ans1}"
