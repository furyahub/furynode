#!/usr/bin/env bash

set -x

furynoded tx gov submit-proposal \
    param-change proposal.json \
    --from $FURY_ACT \
    --keyring-backend test \
    --node ${FURYNODE_NODE} \
    --chain-id $FURYNODE_CHAIN_ID \
    --fees 100000000000000000fury \
    --broadcast-mode block \
    -y