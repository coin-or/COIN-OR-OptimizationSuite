#!/bin/bash

if [ -n "`which gnome-terminal`" ]; then
  gnome-terminal -t "COIN-OR Branch and Cut" -e $1 
  exit
fi

if [ -n "`which xterm`" ]; then
  xterm -T "COIN-OR Branch and Cut" -e $1
  exit
fi

