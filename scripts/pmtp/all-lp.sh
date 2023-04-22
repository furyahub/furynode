#!/usr/bin/env bash

set -x

furynoded q clp all-lp \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID