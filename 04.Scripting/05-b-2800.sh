#!/bin/bash

if [ ${#} -ne 1 ]; then
        exit 1
fi

if [[ $1 =~ ^[a-zA-Z0-9]+$ ]]; then
        echo 'valid'
fi
