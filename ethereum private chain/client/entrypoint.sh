#!/bin/sh
echo "geth --datadir=~/privatechain --bootnodes=$1"
geth --datadir=~/privatechain --bootnodes=$1 