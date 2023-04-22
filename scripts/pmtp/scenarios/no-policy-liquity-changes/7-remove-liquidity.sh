#!/usr/bin/env bash

set -x

furynd tx clp remove-liquidity \
  --from $FURY_ACT \
  --keyring-backend test \
  --symbol cusdt \
  --asymmetry 10000 \
  --wBasis 295 \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y