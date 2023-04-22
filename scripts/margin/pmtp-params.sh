#!/usr/bin/env bash

set -x

furynd q clp pmtp-params \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID