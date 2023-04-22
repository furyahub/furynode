#!/usr/bin/env bash

set -x

furynd tx clp pmtp-rates \
  --blockRate=0.00 \
  --runningRate=0.00 \
  --from=$FURY_ACT \
  --keyring-backend=test \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id=$FURYNODE_CHAIN_ID \
  --broadcast-mode=block \
  -y