#!/usr/bin/env bash

set -x

furynd tx clp add-liquidity \
  --from $FURY_ACT \
  --keyring-backend test \
  --symbol cusdt \
  --nativeAmount 100000000000000000000000 \
  --externalAmount 0 \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y