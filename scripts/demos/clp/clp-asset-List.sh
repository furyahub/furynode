#!/usr/bin/env bash

yes Y | furynoded tx clp create-pool --from user1 --symbol ceth --nativeAmount 200 --externalAmount 200
sleep 8
yes Y | furynoded tx clp create-pool --from user1 --symbol cdash --nativeAmount 100 --externalAmount 100

echo "Query all pools"
sleep 8
furynoded query clp pools

echo "Query specific pool"
sleep 8
furynoded query clp pool ceth

echo "Query Liquidity Provider / Pool creator is the first lp for the pool"
sleep 8
furynoded query clp lp ceth $(furynoded keys show user1 -a)


echo "Query all asset for the liquidity provider "
sleep 8
furynoded query clp assets $(furynoded keys show user1 -a)

