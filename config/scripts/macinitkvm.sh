#!/usr/bin/env bash 
#
sudo modprobe kvm; echo 1 | sudo tee /sys/module/kvm/parameters/ignore_msrs
