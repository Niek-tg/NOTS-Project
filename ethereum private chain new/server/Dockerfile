FROM ubuntu:latest
EXPOSE 30303 

RUN apt-get update 
RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:ethereum/ethereum 
RUN apt-get update && apt-get install -y ethereum 
RUN apt-get install -y dos2unix
RUN apt-get install -y git-all
COPY ./genesis.json /genesis.json
COPY ./eth-utils-master/gethcluster.sh /gethcluster.sh
COPY ./eth-utils-master/gethup.sh /gethup.sh
COPY ./eth-utils-master/netstatconf.sh /netstatconf.sh
COPY ./eth-utils-master/swarm.sh /swarm.sh
COPY ./eth-utils-master/gethkey/main.go /gethkey/main.go
COPY ./entrypoint.sh /entrypoint.sh 

# Fix line endings and set entrypoint
RUN dos2unix /entrypoint.sh && apt-get --purge remove -y dos2unix && rm -rf /var/lib/apt/lists/*
RUN chmod +x /entrypoint.sh
RUN cd /
ENTRYPOINT ["/entrypoint.sh"]
