#!/bin/sh
######################################################################################################################
#export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:$PWD/../bin:$PWD:$PATH
export FABRIC_CFG_PATH=$PWD
CHANNEL_NAME=org1channel1

######################################################################################################################
#set -ev # e: Exit on first error && v: print all commands.
rm -fr ~/.hfc-key-store/* # delete previous creds
mkdir -p ~/.hfc-key-store # copy peer admin credentials into the keyValStore

######################################################################################################################
echo "### remove previous crypto material and config transactions"
rm -fr configtx/*
rm -fr configca/*
mkdir -p ./configtx
mkdir -p ./configca

######################################################################################################################
echo "### generate >>>CRYPTO<<< material"
cryptogen generate --config=./configca.yaml --output=configca
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

######################################################################################################################
echo "### generate >>>GENESIS<<< block for orderer"
configtxgen -profile Genesis -outputBlock ./configtx/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

######################################################################################################################
echo "### generate >>>CHANNEL<<< configuration transaction"
configtxgen -profile Org1Channel1 -outputCreateChannelTx ./configtx/tx-file-channel.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

######################################################################################################################
echo "### generate >>>ANCHER_PEER<<< transaction"
configtxgen -profile Org1Channel1 -outputAnchorPeersUpdate ./configtx/tx-file-anchor.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi