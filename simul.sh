#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

#first we remove all rules targeting the loopback interface ...
tc qdisc del dev lo root 

#... then we add a new rule 
tc qdisc add dev lo root netem delay 50ms 10ms distribution normal
