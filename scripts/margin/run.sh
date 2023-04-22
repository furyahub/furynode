#!/usr/bin/env bash

set -x

killall furynoded

cd ../..
make install
furynoded start --trace
