#!/bin/sh

set -x

furynd tx clp add-liquidity \
  --externalAmount 488436982990 \
  --nativeAmount 96176925423929435353999282 \
  --symbol ceth \
  --from $FURY_ACT \
  --keyring-backend test \
  --fees 100000000000000000fury \
  --node ${FURYNODE_NODE} \
  --chain-id $FURYNODE_CHAIN_ID \
  --broadcast-mode block \
  -y