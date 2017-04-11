In dit labaratorium onderzoek ga ik proberen om een Hyperledger netwerk op te zetten.

De volgende onderdelen zullen behandeld worden in het onderzoek:

- Netwerk creeren
- Eigen organisaties toevoegen met peers
- Eigen smart contract implementeren
- Lees & schrijf operaties op het netwerk uitvoeren
- Meerdere peers toevoegen

## Veelgebruikte commands: ##

Logs weergeven van alle containers:
```
docker logs -f cli
```

Log weergeven van een specifieke container
```
docker logs dev-peer0-mycc-1.0
```

Alle docker containers afsluiten:
```
docker rm -f $(docker ps -aq)
```

Docker container verwijderen:
```
docker rmi -f 38c af0 b04
```

Netwerk starten
```
CHANNEL_NAME=mychannel docker-compose up -d 
```

## generateCfgTrx.sh ##
Dit script voert de configtxgen tool uit. De confixtgen creert twee bestanden. Een "orderer.block" en een "channel.tx".
De orderer block is de genesis block van de chain voor de ordering service. De ordering service is verantwoordelijk voor het identificieren van clients, bied de clients de mogelijkheid om naar de chain te schrijven en te lezen.
In de channel.tx bestand staat de configuratie van de aangemaakte channel.

## Chaincode ##
Chaincode moet geinstalleerd worden op een peer om lees en schrijf operaties te kunnen uitvoeren. Om een transactie te kunnen maken wordt een container opgestart waarin de chaincode uitgevoerd wordt.
Hyperledger heeft de voorkeur voor de term chaincode in plaats van smart contracts.  

## Zelf een netwerk opzetten ##
Open de docker compose file in de e2e_cli map. Zet de lijn 
```
"/bin/bash -c './scripts/script.sh ${CHANNEL_NAME}'"
```
in commentaar door er een "#" voor te zetten. Kill alle containers en start het netwerk opnieuw op.
Nu wordt alleen het netwerk opgestart en worden er verder geen transacties uitgevoerd.

Als eerste gaan we een channel creeren in de CLI container. Open de CLI container door middel van de command: 
```
docker exec -it cli bash
```
Voer vervolgens de volgende command uit: 
```
peer channel create -o orderer0:7050 -c mychannel -f crypto/orderer/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $GOPATH/src/github.com/hyperledger/fabric/peer/crypto/orderer/localMspConfig/cacerts/ordererOrg0.pem
```
Nu een channel gecreerd is kunnen peers de channel joinen. Op moment is de configuratie zo ingesteld dat alleen peer 0 aangeroepen wordt. Door de command hieronder kan een peer zich aanmelden: 
```
peer channel join -b mychannel.block
```
Installeer nu de chaincode op peer 0 door de command:

```
peer chaincode install -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
```
Voer vervolgens de volgende command uit:
```
peer chaincode instantiate -o orderer0:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $GOPATH/src/github.com/hyperledger/fabric/peer/crypto/orderer/localMspConfig/cacerts/ordererOrg0.pem -C mychannel -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 -c '{"Args":["init","a", "100", "b","200"]}' -P "OR ('Org0MSP.member','Org1MSP.member')"
```
Deze command start de chaincode container en creert een beleid met organisaties voor de ledger. Hierbij worden ook de initele waarden meegenomen voor de database. De waarde is een simpele array met hierin een property a die een waarde heeft van 100 en een property b die een waarde heeft van 200. Deze waarden kunnen gemanipuleerd worden door chaincode.

Nu alles opgezet is kunen we de chaincode uitvoeren. Dit kan gedaan worden via de volgende command:
```
peer chaincode invoke -o orderer0:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $GOPATH/src/github.com/hyperledger/fabric/peer/crypto/orderer/localMspConfig/cacerts/ordererOrg0.pem  -C mychannel -n mycc -c '{"Args":["invoke","a","b","10"]}'.
```
Op het einde van deze command staat:
```
"{"Args":["invoke","a","b","10"]}'"
```
Hierbij wordt de invoke methode aangeroepen met een aantal argumenten. Dit zal er voor zorgen dat de a property vermindert wordt met 10 en en de b property verhoogd wordt met 10. Na deze command uitgevoerd te hebbenkan je de waarde uitlezen door een query. Dit kan door:
```
peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'.
```
De waarde die je zou moeten terug krijgen is: 
```
Query Result: 90.
```
