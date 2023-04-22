#!/bin/sh
. ./envs/$1.sh 

# sh ./register-one.sh testnet ixo


TOKEN_REGISTRY_ADMIN_ADDRESS="fury1tpypxpppcf5lea47vcvgy09675nllmcucxydvu"

furynoded tx tokenregistry register ./$FURYCHAIN_ID/$2.json \
  --node $FURY_NODE \
  --chain-id $FURYCHAIN_ID \
  --from $TOKEN_REGISTRY_ADMIN_ADDRESS \
  --keyring-backend $KEYRING_BACKEND \
  --gas=500000 \
  --gas-prices=0.5fury \
  -y