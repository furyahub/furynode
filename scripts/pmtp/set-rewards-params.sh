#!/usr/bin/env bash

set -x

furynd tx clp reward-params \
  --cancelPeriod 43200 \
  --lockPeriod 100800 \
  --from=$FURY_ACT \
  --keyring-backend=test \
  --fees 100000000000000000fury \
  --gas 500000 \
  --node ${FURYNODE_NODE} \
  --chain-id=$FURYNODE_CHAIN_ID \
  --broadcast-mode=block \
  -y

# furynd tx clp reward-params \
#   --cancelPeriod 66825 \
#   --lockPeriod 124425 \
#   --from=$FURY_ACT \
#   --keyring-backend=test \
#   --fees 100000000000000000fury \
#   --gas 500000 \
#   --node ${FURYNODE_NODE} \
#   --chain-id=$FURYNODE_CHAIN_ID \
#   --broadcast-mode=block \
#   -y

# furynd tx clp reward-params \
#   --cancelPeriod 66825 \
#   --lockPeriod 100800 \
#   --from=$FURY_ACT \
#   --keyring-backend=test \
#   --fees 100000000000000000fury \
#   --gas 500000 \
#   --node ${FURYNODE_NODE} \
#   --chain-id=$FURYNODE_CHAIN_ID \
#   --broadcast-mode=block \
#   -y