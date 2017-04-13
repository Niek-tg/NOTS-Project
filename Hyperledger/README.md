In dit labaratorium onderzoek ga ik een Hyperledger netwerk op te zetten.

Nog verwerken in onderzoek:

- Pullen van docker images (http://hyperledger-fabric.readthedocs.io/en/latest/getting_started.html#prerequisites)
- Configuratie bestanden: onfigtx.yaml en docker-compose.yaml uitleggen
- Concepten Hyperledger uitleggen

## Veelgebruikte commands: ##

Actieve dockers weergeven:
```
docker ps
```

Logs weergeven van alle containers:
```
docker logs -f <naam>
```

Log weergeven van een specifieke container:
```
docker logs <naam>
```

Alle docker containers afsluiten:
```
docker rm -f $(docker ps -aq)
```

Docker container verwijderen :
```
docker rmi -f <id, eerste 3 tekens> <(optioneel) id, eerste 3 tekens>
```

## Een eigen netwerk starten ##
Om een netwerk te starten wordt docker gebruikt. In dit voorbeeld zullen meerdere images gebruikt worden die elk een eigen verantwoordelijk heeft. Om een netwerk te kunnen starten is een linux machine aangeraden.

Download docker composer:

```
sudo curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)"
```

Download de programmeertaal Go via https://golang.org/dl/. Minimaal versie 1.8.1 is verplicht.
Om GO te kunnen gebruiken vanaf de terminal moeten er een aantal paden toegevoegd worden in het bashrc bestand. 

Open een terminal met sudo en open het bashrc bestand:
```
nano ~/.bashrc
```

Voeg de regels hieronder toe aan uw bash bestand onderin. Controleer of de paden overeenkomen met uw eigen paden.
```
export GOPATH=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin
```

U kunt het bestand verlaten door de volgende stappen:

- control x
- y
- enter

Om de fabric repository te kunnen clonen is het aangeraden om git te installeren. U kunt ook handmatig de repository downloaden vanaf https://github.com/hyperledger/fabric.

Via git kan de repository gecloned worden via:

```
git clone https://github.com/hyperledger/fabric.git
```

Zodra de repository gecloned is moet u de map kopieren naar de volgende plek:
```
/usr/local/go/src/github.com
```

Het uiteindelijke pad ziet er dan als volgt uit:

```
/usr/local/go/src/github.com/hyperledger/fabric/
```

Navigeer naar de map hierboven. In deze map moet de configtxgen tool aangeroepen worden.

De configtxgen tool is verantwoordelijk voor het maken een Orderer bootstrap block en een Fabric channel configuratie.

De orderer block is de genesis block (eerste block in de chain) voor de orderering service. De channel configuratie bestand wordt verzonden naar de orderer service wanneer de channel aangemaakt wordt. De ordering service is verantwoordelijk voor het identificieren van clients, bied de clients de mogelijkheid om naar de chain te schrijven en te lezen.

Om de configtxgen tool te kunnen gebruiken moet de tool eerst gebuild worden. Dit kan door middel van de volgende command:

```
make configtxgen
```

Om te voorkomen dat Hyperledger end to end tests gaat draaien moet de composer compose file aangepast worden. Hiervoor is het noodzakelijk dat regelnummer 205 in commentaar wordt gezet. Dit kan door een "#" teken voor de regel in te voegen. Dit zorg er voor dat we handmatig zelf een netwerk moeten opzetten.

De regel ziet er als volgt uit nadat de regel in commentaar is gezet:

```
# command: /bin/bash -c './scripts/script.sh ${CHANNEL_NAME}'
```

Vanaf dit punt moet verder gewerkt worden in de e2e_cli map. De repository van Hyperledger komt standaard met een aantal end to end tests. Deze end to end tests dienen een goede basis om een eigen netwerk op te zetten. 

Navigeer nu naar de e2e_cli map:

```
cd /usr/local/go/src/github.com/hyperledger/fabric/examples/e2e_cli/
```

Nu zal de generateCfgTrx shell bestand aangeroepen moeten worden. Dit shell bestand is een hulpmiddel die de configxtgen tool build en aanroept met een vooraf opgegeven properties zoals het pad naar de genesis block en channel configuratie. Het is van belang dat je dezelfde channel naam gebruikt. Je kan namelijk meerdere channels starten op een machine.


Creeer de configuratie die nodig is voor het werk:

```
./generateCfgTrx.sh mychannel
```

Nu de configuratie compleet is kan het netwerk worden gestart.

Door de volgende command worden alle docker containers opgestart en verwezen naar de mychannel. 

```
CHANNEL_NAME=mychannel docker-compose up -d 
```

Om commands uit te voeren in het netwerk levert Hyperledger een image waarin commands uitgevoerd kunnen worden op het netwerk.
Deze image heeft cli. Voer de volgende docker command uit om in de container te komen:

```
docker exec -it cli bash
```

Nu je in de docker container zit kan je een channel creeren. In de command hieronder wordt de channel meegegeven. Als je een andere channel naam gebruikt verander dan de 'mychannel' naar jouw opgegeven channel naam. 

Start een nieuwe channel:

```
peer channel create -o orderer0:7050 -c mychannel -f crypto/orderer/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $GOPATH/src/github.com/hyperledger/fabric/peer/crypto/orderer/localMspConfig/cacerts/ordererOrg0.pem
```

Nu een channel gecreerd is kunnen peers de channel joinen. Op moment is de configuratie zo ingesteld dat alleen peer 0 aangeroepen wordt. Door de command hieronder kan een peer zich aanmelden:

```
peer channel join -b mychannel.block
```

Om transacties op het netwerk uit te kunnen voeren moet chaincode geinstalleerd worden. Om een transactie te kunnen maken wordt een container opgestart waarin de chaincode uitgevoerd wordt. Hyperledger heeft de voorkeur voor de term chaincode in plaats van smart contracts. Daarom zul je vaak de term chaincode tegenkomen en niet smart contracts.

Installeer de vooraf gedefinieerde chaincode op peer 0:

```
peer chaincode install -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02
```

Om het netwerk te vullen met data kunnen we de init methode aanroepen van de chaincode. In de command hieronder zie je dat de init methode wordt aangeroepen van de chaincode en property a op 100 wordt gezet en property b naar 200. Daarnaast zie je op het eind van de command twee participants staan. Dit geeft aan dat een transactie geslaagd is zodra een van deze participants aangeeft dat de transactie valide is hij toegevoegd zal worden in het netwerk. 

Chaincode in Hyperledger wordt uitgevoerd in een eigen docker container. 

Netwerk vullen met data:

```
peer chaincode instantiate -o orderer0:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $GOPATH/src/github.com/hyperledger/fabric/peer/crypto/orderer/localMspConfig/cacerts/ordererOrg0.pem -C mychannel -n mycc -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 -c '{"Args":["init","a", "100", "b","200"]}' -P "OR ('Org0MSP.member','Org1MSP.member')"
```

Nu het netwerk gestart en gevuld is met data kunnen we chaincode transacties uitvoeren. In het voorbeeld hieronder wordt de invoke methode aangeroepen. Hierbij wordt a property vermindert met de waarde tien en wordt property b opgehoogd met 10.

```
peer chaincode invoke -o orderer0:7050  --tls $CORE_PEER_TLS_ENABLED --cafile $GOPATH/src/github.com/hyperledger/fabric/peer/crypto/orderer/localMspConfig/cacerts/ordererOrg0.pem  -C mychannel -n mycc -c '{"Args":["invoke","a","b","10"]}'.

```

Om te controleren of de transactie geslaagd is kunnen we een lees query uitvoeren. In het voorbeeld hieronder lezen we propery a uit. 

Command om property a uit te lezen:

```
peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'.
```

De waarde die je zou moeten terug krijgen is: 

```
Query Result: 90.
```

# Hyperledger concepten #
Hieronder worden een aantal belangrijke concepten uitgelegd van Hyperledger.

## Endorsement policy ##
In een endorsement policy staat beschreven hoe een peer moet omgaan met een transactie. Zo kan je opgeven dat er drie organisaties zijn waarvan een van de drie moet aangeven dat een transactie geldig is.

Een endorsement policy heeft twee hoofdcomponenten, een principal en een treshold gate.
Een principal identifieert een entity waarvan een signature wordt verwacht. De treshold gate bevat de hoeveelheid principals die nodig zijn om de transactie te kunnen afronden en een lijst van principals die een transactie mogen accepteren of afkeuren.

Hieronder volgt een voorbeeld:

```
T(2, 'A', ' B', 'C')
``` 

De policy hierboven wilt de signatures hebben van minimaal twee participant in de opgegeven lijst. De participants in dit voorbeeld zijn: A,B en C.

Het voorbeeld hieronder is wat complexer:

```
T(1, 'A', T(2, 'B', 'C'))
``` 

Hierin geeft de policy aan, of een signature van principal A te willen of een signature van B en C.


## Bronnen ##

- Creeren van een eigen netwerk
http://hyperledger-fabric.readthedocs.io/en/latest/getting_started.html#start-the-network
