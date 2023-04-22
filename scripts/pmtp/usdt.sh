#!/usr/bin/env bash

set -x

furynd q clp pool cusdt \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID