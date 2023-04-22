#!/usr/bin/env bash

set -x

furynd q margin whitelist \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID