#!/usr/bin/env bash

cp $GOPATH/src/new/furynd $GOPATH/bin/
cosmovisor start >> furynode.log 2>&1  &