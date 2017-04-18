FROM ubuntu:latest
EXPOSE 8545

RUN apt-get update 
RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:ethereum/ethereum 
RUN apt-get update && apt-get install -y ethereum 

CMD geth --rpc -rpcapi "personal,eth,web3" --rpcaddr "0.0.0.0" --rpccorsdomain "http://localhost:3000"
