#!/bin/sh

set -x

furynd tx clp reward-params \
  --lockPeriod 0 \
  --cancelPeriod 0 \
  --from $FURY_ACT \
  --keyring-backend test \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y