#!/usr/bin/bash
# quem precisa de makefile? :P

# $1 = which tb to run
# $2 = which file to use as mem
# $3 = how many nanoseconds for which to run it


printf "deleting ./build/*...\n"
trash ./build/*
# trash because rm is scary

printf "setting neanderram.mem to "$2"...\n"
cp $2 ./build/neanderram.mem

printf "building...\n"
cd build
ghdl -a ../vhdl/*.vhdl
ghdl -e $1

printf "simulating...\n"
touch ../waves/$1$2.ghw
wave=`readlink -f ../waves/$1$2.ghw`
ghdl -r $1 --stop-time=$3ns --wave=$wave

printf "wave written to "$wave"\nDONE\n"

