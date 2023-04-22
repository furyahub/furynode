#!/usr/bin/env bash

set -x

furynd q gov proposals \
    --node ${FURYNODE_NODE} \
    --chain-id $FURYNODE_CHAIN_ID