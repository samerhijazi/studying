#!/bin/sh
######################################################################################################################
export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=sh-channel
######################################################################################################################
docker-compose -f docker-compose.yml kill && docker-compose -f docker-compose.yml down
#set -ev # e: Exit on first error && v: print all commands.
######################################################################################################################
# remove previous crypto material and config transactions
rm -rf ~/.hfc-key-store/*
rm -rf configtx/*
rm -rf configcr/*

mkdir -p ~/.hfc-key-store
mkdir -p configtx
mkdir -p configcr

######################################################################################################################
echo "### generate >>>CRYPTO<<< material"
cryptogen generate --config=./configcr.yaml --output=configcr
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

######################################################################################################################
echo "### generate >>>GENESIS<<< block for orderer"
configtxgen -profile OneOrgGenesis -outputBlock ./configtx/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

######################################################################################################################
echo "### generate >>>CHANNEL<<< configuration transaction"
configtxgen -profile OneOrgChannel -outputCreateChannelTx ./configtx/channel.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

######################################################################################################################
echo "### generate >>>ANCHER<<< transaction"
configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./configtx/anchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi
