#!/usr/bin/bash

# $1 = which tb to run
# $2 = which file to use as mem

printf "deleting ./build/*...\n"
trash ./build/*

printf "setting mem to "$2"...\n"
cp ./material/vhdl-Memória/$2.mem ./build/neanderram.mem

printf "building...\n"
cd build
ghdl -a ../vhdl/*.vhdl
ghdl -e $1
touch ../waves/$1.ghw
wave=`readlink -f ../waves/$1.ghw`
ghdl -r $1 --stop-time=256ns --wave=$wave

