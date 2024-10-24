#!/bin/bash

current_hostname=$(hostname)

read -p "Please enter the hostname [${current_hostname}]: " hostname

hostname=${hostname:-$current_hostname}
echo "You entered: $hostname"

# sudo swapoff -a



