#!/usr/bin/env bash

set -x

furynd q clp all-lp \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID