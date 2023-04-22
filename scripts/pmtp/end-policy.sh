#!/usr/bin/env bash

set -x

furynoded tx clp pmtp-rates \
  --endPolicy=true \
  --from=$FURY_ACT \
  --keyring-backend=test \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id=$FURYNODE_CHAIN_ID \
  --broadcast-mode=block \
  -y