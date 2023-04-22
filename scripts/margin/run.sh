#!/usr/bin/env bash

set -x

killall furynd

cd ../..
make install
furynd start --trace
