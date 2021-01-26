#!/bin/bash

######################################################################################################################
export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
######################################################################################################################
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images dev-* -aq)
######################################################################################################################
set -ev
######################################################################################################################
rm -fr ~/.hfc-key-store/*
rm -fr configtx/*
rm -fr configca/*
mkdir -p ~/.hfc-key-store
mkdir -p ./configtx
mkdir -p ./configca
######################################################################################################################
# generate crypto material
cryptogen generate --config=./configca.yaml --output=configca
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi
######################################################################################################################
# generate >>> GENESIS <<< block for orderer
configtxgen -profile Genesis -outputBlock ./configtx/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi
######################################################################################################################
# generate >>> CHANNEL <<< configuration transaction
configtxgen -profile Org1Channel1 -outputCreateChannelTx ./configtx/org1channel1.tx -channelID org1channel1
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi
######################################################################################################################
# generate >>> ANCHER PEER <<< transaction
configtxgen -profile Org1Channel1 -outputAnchorPeersUpdate ./configtx/org1anchorpeer0.tx -channelID org1channel1 -asOrg Org1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi
######################################################################################################################
docker-compose -f docker-compose.yml up -d orderer.example.com peer0.org1.example.com peer1.org1.example.com cli

docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" -it peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c org1channel1 -f /etc/hyperledger/configtx/org1channel1.tx
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" -it peer0.org1.example.com peer channel join -b org1channel1.block
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" -it peer1.org1.example.com peer channel fetch oldest org1channel1.block -o orderer.example.com:7050 -c org1channel1
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" -it peer1.org1.example.com peer channel join -b org1channel1.block
