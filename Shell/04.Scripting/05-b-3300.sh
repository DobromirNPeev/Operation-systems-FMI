#!/bin/bash

echo 'Enter 3 files names:'
read file1 file2 file3

if [ ! -f $file1 ] || [ ! -f $file2 ] || [ ! -f $file3 ];then
        echo 'Invalid input'
        exit 1
fi

 paste ${file1} ${file2} | sort > $file3
