#!/bin/sh

set -x

furynd tx clp set-lppd-params \
  --path lppd-params.json \
  --from $FURY_ACT \
  --keyring-backend test \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y