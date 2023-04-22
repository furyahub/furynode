#!/bin/sh

set -x

furynd tx clp remove-liquidity-units \
  --withdrawUnits 1 \
  --symbol ceth \
  --from $FURY_ACT \
  --keyring-backend test \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y