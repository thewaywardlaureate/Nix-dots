#!/usr/bin/env bash  
#
while true
do
pkill wbg
ls ~/Pictures/Wallpapers/ |sort -R |tail -$N |while read file 
do
pkill wbg
wbg ~/Pictures/Wallpapers/$file &
sleep 10s 
pkill wbg 
done
done
