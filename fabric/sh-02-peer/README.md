# Template
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" -it peer1.org1.example.com bash

# Add new Peer
Update "configcr.yaml" >> Template: Count: 2
Update "docker-compose.yaml" >> new Peer
---
cryptogen extend --input="./configcr" --config=./configcr.yaml
configtxgen -profile OneOrgGenesis -outputBlock ./configtx/genesis.block
---
peer channel fetch oldest ​sh-channel​.​block​ -​c​ sh-channel​ --​orderer​ ​orderer.example.com:7050
peer channel join -b ​sh-channel.block
peer channel list