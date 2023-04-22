#!/usr/bin/env bash

set -x

furynoded q margin \
  positions-for-address $ADMIN_ADDRESS \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID