#!/usr/bin/bash

rerun='false'
mem='~/uni/1/sd/neander/vhdl-Memória/neanderram.mem'

while getopts "r:m:" arg; do
    case $arg in
        re)
            rerun='true'
            ;;
        mem)
            mem=$OPTARG
            ;;
    esac;
done

if $rerun == "true"; then
    echo "Not a rerun, will launch gtkwave"
fi
echo "will copy mem from $mem"

# trash ./build/*
# cp ~/uni/1/sd/neander/vhdl-Memória/neanderram.mem ./build/neanderram.mem
# 
# cd build
# ghdl -a ../vhdl/*
# ghdl -e $1
# 
# touch ../waves/$1.ghw 
# wave=`readlink -f ../waves/$1.ghw`
# ghdl -r $1 --stop-time=180ns --wave=$wave
# 
# 
# if rerun; then
#     printf "$wave updated.\n"
# else
#     gtkwave $wave &
# fi
