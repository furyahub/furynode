#!/bin/bash 

addr=$1
shift

furynd q auth account ${addr:=${VALIDATOR1_ADDR}} -o json | jq
