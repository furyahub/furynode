#!/usr/bin/env bash

set -x

furynoded q margin whitelist \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID