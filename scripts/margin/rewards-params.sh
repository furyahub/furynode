#!/usr/bin/env bash

set -x

furynoded q clp reward-params \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID