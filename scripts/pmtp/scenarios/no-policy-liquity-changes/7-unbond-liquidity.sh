#!/usr/bin/env bash

set -x

furynoded tx clp unbond-liquidity \
  --from $FURY_ACT \
  --keyring-backend test \
  --symbol cusdt \
  --units 10000000000 \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y