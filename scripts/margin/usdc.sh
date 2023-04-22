#!/usr/bin/env bash

set -x

furynd q clp pool cusdc \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID