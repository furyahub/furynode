#!/usr/bin/env bash

set -x

furynd tx clp pmtp-params \
  --pmtp_start=31 \
  --pmtp_end=1030 \
  --epochLength=100 \
  --rGov=0.10 \
  --from=$FURY_ACT \
  --keyring-backend=test \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id=$FURYNODE_CHAIN_ID \
  --broadcast-mode=block \
  -y