#!/bin/sh
#GETH=./geth bash /gethcluster.sh ~/nodes 5 15452          05   77.160.58.3  -mine 
GETH=./geth bash gethcluster.sh ~ 2 2 3301 05 77.160.58.3 -mine
#GETH=./geth bash gethcluster.sh <root> <n> <network_id> <runid> <IP> [[params]...]