#!/bin/bash

#set -ev # e: Exit on first error && v: print all commands.

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

######################################################################################################################
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up -d ca.example.com orderer.example.com peer0.org1.example.com

export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

echo "### Create the channel"
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" -it peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c org1channel1 -f /etc/hyperledger/configtx/tx-file-channelfile.tx

echo "### Join peer0.org1.example.com to the channel."
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" -it peer0.org1.example.com peer channel join -b org1channel1.block