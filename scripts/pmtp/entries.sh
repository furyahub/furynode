#!/usr/bin/env bash

set -x

furynoded q tokenregistry entries \
    --node ${FURYNODE_NODE} \
    --chain-id $FURYNODE_CHAIN_ID | jq