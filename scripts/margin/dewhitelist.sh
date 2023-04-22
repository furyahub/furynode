#!/usr/bin/env bash

set -x

furynd tx margin dewhitelist fury1syavy2npfyt9tcncdtsdzf7kny9lh777yqc2nd \
  --from $FURY_ACT \
  --keyring-backend test \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y