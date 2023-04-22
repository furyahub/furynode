#!/usr/bin/env bash

set -x

furynd tx margin open \
  --from $FURY_ACT \
  --keyring-backend test \
  --borrow_asset cusdc \
  --collateral_asset fury \
  --collateral_amount 1000000000000000000000 \
  --position long \
  --leverage 2 \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y