#!/usr/bin/env bash

set -x

furynd q margin params \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID