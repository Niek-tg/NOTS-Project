#!/bin/sh
/wait-for-it.sh 172.20.0.2:30303 -- echo "host node is up!"
geth init /genesis.json && geth --bootnodes "enode://0629f22c8ab48fa241fc3ed311d8ae973735d61c3e8dc9b87d2be974637931bde24a03658d0a370571be643cf615bd60ae5d9d29af69cf0ee57465b0d50e8469@172.20.0.2:30303" --networkid 15420 --rpc -rpcapi "personal,eth,web3" --rpcaddr "0.0.0.0" --rpccorsdomain "http://localhost:3000"

#enode://0629f22c8ab48fa241fc3ed311d8ae973735d61c3e8dc9b87d2be974637931bde24a03658d0a370571be643cf615bd60ae5d9d29af69cf0ee57465b0d50e8469@172.20.0.2:30303