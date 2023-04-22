#!/usr/bin/env bash

set -x

furynoded q clp params \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID