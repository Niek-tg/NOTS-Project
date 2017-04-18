FROM ubuntu:latest
EXPOSE 30303 
RUN apt-get update 
RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:ethereum/ethereum 
RUN apt-get update && apt-get install -y ethereum 
COPY ./genesis.json / ./password.txt /
CMD geth --password /password.txt account new && geth init /genesis.json && geth --networkid 15420 bootnode --nodekeyhex 896e1ebbbf435d88451d3c7b1e8dcff12904bc66ff19d8dfd65d36cbd134ecb