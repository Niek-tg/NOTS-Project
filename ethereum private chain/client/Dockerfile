FROM ubuntu:latest
EXPOSE 30303 
EXPOSE 8545
RUN apt-get update 
RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:ethereum/ethereum 
RUN apt-get update && apt-get install -y ethereum 
RUN apt-get update && apt-get install -y dos2unix
COPY ./wait-for-it.sh /wait-for-it.sh
COPY ./genesis.json /genesis.json
COPY ./entrypoint.sh /entrypoint.sh 

# Fix line endings and set entrypoint
RUN dos2unix /entrypoint.sh && apt-get --purge remove -y dos2unix && rm -rf /var/lib/apt/lists/*
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
