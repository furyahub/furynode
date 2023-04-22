#!/usr/bin/env bash

set -x

furynd tx margin update-pools ./pools.json \
  --closed-pools ./closed-pools.json \
  --from=$FURY_ACT \
  --keyring-backend=test \
  --fees 100000000000000000fury \
  --gas 500000 \
  --node ${FURYNODE_NODE} \
  --chain-id=$FURYNODE_CHAIN_ID \
  --broadcast-mode=block \
  -y