#!/usr/bin/env bash

set -x

furynoded tx bank send \
    $FURY_ACT \
    fury144w8cpva2xkly74xrms8djg69y3mljzplx3fjt \
    9299999999750930000fury \
    --keyring-backend test \
    --node ${FURYNODE_NODE} \
    --chain-id $FURYNODE_CHAIN_ID \
    --fees 100000000000000000fury \
    --broadcast-mode block \
    -y