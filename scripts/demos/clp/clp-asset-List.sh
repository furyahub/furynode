#!/usr/bin/env bash

yes Y | furynd tx clp create-pool --from user1 --symbol ceth --nativeAmount 200 --externalAmount 200
sleep 8
yes Y | furynd tx clp create-pool --from user1 --symbol cdash --nativeAmount 100 --externalAmount 100

echo "Query all pools"
sleep 8
furynd query clp pools

echo "Query specific pool"
sleep 8
furynd query clp pool ceth

echo "Query Liquidity Provider / Pool creator is the first lp for the pool"
sleep 8
furynd query clp lp ceth $(furynd keys show user1 -a)


echo "Query all asset for the liquidity provider "
sleep 8
furynd query clp assets $(furynd keys show user1 -a)

