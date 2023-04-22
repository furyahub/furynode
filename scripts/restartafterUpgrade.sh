#!/usr/bin/env bash

cp $GOPATH/src/new/furynoded $GOPATH/bin/
cosmovisor start >> furynode.log 2>&1  &