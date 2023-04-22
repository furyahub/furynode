#!/usr/bin/env bash

set -x

furynoded tx clp add-liquidity \
  --from $FURY_ACT \
  --keyring-backend test \
  --symbol cusdt \
  --nativeAmount 1000000000000000000000000 \
  --externalAmount 25378853317 \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y