#!/usr/bin/bash

mkdir -p build

printf "ghdl -a "
ls vhdl

cd build
ghdl -a ../vhdl/*
cd ..
