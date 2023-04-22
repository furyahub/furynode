#!/bin/sh
. ./envs/$1.sh 

# sh ./register-all.sh testnet


TOKEN_REGISTRY_ADMIN_ADDRESS="fury1tpypxpppcf5lea47vcvgy09675nllmcucxydvu"

furynd tx tokenregistry register-all ./$FURYCHAIN_ID/tokenregistry.json \
  --node $FURY_NODE \
  --chain-id $FURYCHAIN_ID \
  --from $TOKEN_REGISTRY_ADMIN_ADDRESS \
  --keyring-backend $KEYRING_BACKEND \
  --gas=500000 \
  --gas-prices=0.5fury \
  -y