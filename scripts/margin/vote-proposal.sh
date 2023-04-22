#!/usr/bin/env bash

set -x

furynd tx gov vote 2 yes \
  --from ${FURY_ACT} \
  --keyring-backend test \
  --chain-id="${FURYNODE_CHAIN_ID}" \
  --node="${FURYNODE_NODE}" \
  --fees=100000000000000000fury \
  --broadcast-mode=block \
  -y