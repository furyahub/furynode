#!/usr/bin/env bash

set -x

furynoded tx clp create-pool \
  --from $FURY_ACT \
  --keyring-backend test \
  --symbol cusdt \
  --nativeAmount 1550459183129248235861408 \
  --externalAmount 174248776094 \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y