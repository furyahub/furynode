#!/usr/bin/env bash

set -x

furynoded q clp pool cusdt \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID