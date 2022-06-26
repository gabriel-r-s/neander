#!/usr/bin/bash

cd build
ghdl -a ../vhdl/*
ghdl -e $1
touch ../waves/$1.ghw 
wave=`readlink -f ../waves/$1.ghw`
ghdl -r $1 --stop-time=180ns --wave=$wave

if [ "$2" = "-re" ]; then
    printf "$wave updated.\n"
else
    gtkwave $wave &
fi
