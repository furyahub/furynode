#!/usr/bin/env bash

set -x

furynoded q bank balances $ADMIN_ADDRESS \
    --node ${FURYNODE_NODE} \
    --chain-id $FURYNODE_CHAIN_ID