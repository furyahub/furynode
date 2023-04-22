#!/usr/bin/env bash

set -x

furynoded tx clp swap \
  --from=$FURY_ACT \
  --keyring-backend=test \
  --sentSymbol=cusdc \
  --receivedSymbol=fury \
  --sentAmount=1000000000000 \
  --minReceivingAmount=0 \
  --fees=100000000000000000fury \
  --gas=500000 \
  --node=${FURYNODE_NODE} \
  --chain-id=${FURYNODE_CHAIN_ID} \
  --broadcast-mode=block \
  -y