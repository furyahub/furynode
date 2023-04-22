#!/bin/sh

# sh ./deregister-one.sh testnet ixo

. ./envs/$1.sh 

TOKEN_REGISTRY_ADMIN_ADDRESS="fury1tpypxpppcf5lea47vcvgy09675nllmcucxydvu"

furynd tx tokenregistry deregister $2 \
  --node $FURY_NODE \
  --chain-id $FURYCHAIN_ID \
  --from $TOKEN_REGISTRY_ADMIN_ADDRESS \
  --keyring-backend $KEYRING_BACKEND \
  --gas=500000 \
  --gas-prices=0.5fury \
  -y