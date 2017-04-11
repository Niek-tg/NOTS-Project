# NOTS-Project
Collection of the experiments we did during the project of the .NET On The Server semester.

### Ethereum private chain
The Ethereum private chain is an experiment where we use the [official Go implementation of the Ethereum protocol](https://geth.ethereum.org/) to run as a private ledger and see how it works. The implementation we created has been made in Docker. It holds two `Dockerfiles` and a `docker-compose` file which sets up the correct infrastructure. 

#### How to use it
To be able to use the Ethereum private chain project, you should have the latest version of Docker and Docker-compose installed. Open a terminal in the `Ethereum private chain` folder and type `docker-compose up`. Then it spins up two instances: an EthereumHost, which initializes the new blockchain and exposes a enode address for the other nodes to connect to. 

---------NOT WORKING AT THE MOMENT-----------

The second instance which is spunned up is the EthereumClient. This client is able to connect to the enode of the EthereumHost and adds itself to the private network of nodes which are in the chain.

\--------------------------------------------------------- 

#### Problems we encountered
As you can read in the section above, the functionality of the EthereumClient is not functioning correctly at the moment. We are encountering difficult problems which we cannot fix at the moment, due to the lack of knowledge. The problem is that the Enode string which is generated in the EthereumServer has to be dynamicly injected in the EthereumHost container. At the moment we do not see an option to dynamically take the generated enode string and pass it to the EthereumClient at startup. If you have a solution, let us know!