FROM ubuntu:latest
EXPOSE 30303 
RUN apt-get update 
RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:ethereum/ethereum 
RUN apt-get update && apt-get install -y ethereum 
COPY ./genesis.json / ./password.txt /
CMD geth --password /password.txt account new && geth init /genesis.json && tail -f /dev/null