#!/bin/bash

if [[ $# -ne 2 ]]; then
        echo "Invalid number of parameters"
        exit 1
fi

if [[ ! -d $1 ]]; then
        echo "The given directory does not exist"
        exit 1
fi

wget -r -q -np -nd -R "index.html*"  -L $2 -P $1
echo "Download finished. The files are saved in directory $1"
