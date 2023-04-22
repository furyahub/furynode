#!/bin/sh

# sh ./deregister-all.sh testnet

. ./envs/$1.sh 

mkdir -p ./$FURYCHAIN_ID
rm -f ./$FURYCHAIN_ID/temp.json
rm -f ./$FURYCHAIN_ID/temp2.json
rm -f ./$FURYCHAIN_ID/tokenregistry.json

furynoded q tokenregistry add-all ./$FURYCHAIN_ID/registry.json | jq > $FURYCHAIN_ID/temp.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/temp.json ./$FURYCHAIN_ID/cosmos.json | jq > $FURYCHAIN_ID/tokenregistry.json
rm ./$FURYCHAIN_ID/temp.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/tokenregistry.json ./$FURYCHAIN_ID/akash.json | jq > $FURYCHAIN_ID/temp.json
rm ./$FURYCHAIN_ID/tokenregistry.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/temp.json ./$FURYCHAIN_ID/sentinel.json | jq > $FURYCHAIN_ID/tokenregistry.json
rm ./$FURYCHAIN_ID/temp.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/tokenregistry.json ./$FURYCHAIN_ID/iris.json | jq > $FURYCHAIN_ID/temp.json
rm ./$FURYCHAIN_ID/tokenregistry.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/temp.json ./$FURYCHAIN_ID/persistence.json | jq > $FURYCHAIN_ID/tokenregistry.json
rm ./$FURYCHAIN_ID/temp.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/tokenregistry.json ./$FURYCHAIN_ID/crypto-org.json | jq > $FURYCHAIN_ID/temp.json
rm ./$FURYCHAIN_ID/tokenregistry.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/temp.json ./$FURYCHAIN_ID/regen.json | jq > $FURYCHAIN_ID/tokenregistry.json
rm ./$FURYCHAIN_ID/temp.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/tokenregistry.json ./$FURYCHAIN_ID/terra.json | jq > $FURYCHAIN_ID/temp.json
rm ./$FURYCHAIN_ID/tokenregistry.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/temp.json ./$FURYCHAIN_ID/osmosis.json | jq > $FURYCHAIN_ID/tokenregistry.json
rm ./$FURYCHAIN_ID/temp.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/tokenregistry.json ./$FURYCHAIN_ID/juno.json | jq > $FURYCHAIN_ID/temp.json
rm ./$FURYCHAIN_ID/tokenregistry.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/temp.json ./$FURYCHAIN_ID/ixo.json | jq > $FURYCHAIN_ID/tokenregistry.json
rm ./$FURYCHAIN_ID/temp.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/tokenregistry.json ./$FURYCHAIN_ID/emoney.json | jq > $FURYCHAIN_ID/temp.json
rm ./$FURYCHAIN_ID/tokenregistry.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/temp.json ./$FURYCHAIN_ID/likecoin.json | jq > $FURYCHAIN_ID/tokenregistry.json
rm ./$FURYCHAIN_ID/temp.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/tokenregistry.json ./$FURYCHAIN_ID/bitsong.json | jq > $FURYCHAIN_ID/temp.json
rm ./$FURYCHAIN_ID/tokenregistry.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/temp.json ./$FURYCHAIN_ID/band.json | jq > $FURYCHAIN_ID/tokenregistry.json
rm ./$FURYCHAIN_ID/temp.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/tokenregistry.json ./$FURYCHAIN_ID/emoney-eeur.json | jq > $FURYCHAIN_ID/temp.json
rm ./$FURYCHAIN_ID/tokenregistry.json
furynoded q tokenregistry add ./$FURYCHAIN_ID/temp.json ./$FURYCHAIN_ID/terra-uusd.json | jq > $FURYCHAIN_ID/tokenregistry.json
rm ./$FURYCHAIN_ID/temp.json