#!/usr/bin/env bash

set -x

echo ${ADMIN_MNEMONIC} | furynd keys add ${FURY_ACT} --recover --keyring-backend=test