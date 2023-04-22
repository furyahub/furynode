#!/usr/bin/env bash

set -x

furynoded tx clp set-symmetry-threshold \
  --threshold=0.000000005 \
  --from=$FURY_ACT \
  --keyring-backend=test \
  --fees=100000000000000000fury \
  --gas=500000 \
  --node=${FURYNODE_NODE} \
  --chain-id=$FURYNODE_CHAIN_ID \
  --broadcast-mode=block \
  -y