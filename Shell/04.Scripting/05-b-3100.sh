#!/bin/bash

echo 'Enter username:'
read username

ans=0
while read line; do
        if echo $line | grep -q  $username ;then
                ans=$((ans+1))
        fi
done < <(who)

echo $ans
