#!/usr/bin/env bash

set -x

furynd q clp pools \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID