#!/bin/bash 

addr=$1
shift

furynoded q auth account ${addr:=${VALIDATOR1_ADDR}} -o json | jq
