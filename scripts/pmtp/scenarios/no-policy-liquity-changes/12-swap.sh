#!/usr/bin/env bash

set -x

furynd tx clp swap \
  --from $FURY_ACT \
  --keyring-backend test \
  --sentSymbol fury \
  --receivedSymbol cusdt \
  --sentAmount 100000000000000000000000 \
  --minReceivingAmount 0 \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y