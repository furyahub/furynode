#!/usr/bin/env bash

set -x

furynoded q gov proposals \
    --node ${FURYNODE_NODE} \
    --chain-id $FURYNODE_CHAIN_ID