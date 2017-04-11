FROM ubuntu:latest
EXPOSE 8545

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN apt-get update && apt-get install -y ethereum
