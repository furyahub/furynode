#!/usr/bin/env bash

set -x

furynoded tx margin close \
  --from $FURY_ACT \
  --id 7 \
  --keyring-backend test \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y