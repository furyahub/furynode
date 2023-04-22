#!/usr/bin/env bash


rm -rf ~/.furynd
rm -rf furynode.log
rm -rf testlog.log

cd "$(dirname "$0")"

./init.sh
sleep 8
furynd start >> furynode.log 2>&1  &
sleep 8

yes Y | furynd tx clp create-pool --from akasha --symbol catk --nativeAmount 1000 --externalAmount 1000
sleep 8
yes Y | furynd tx clp create-pool --from akasha --symbol cbtk --nativeAmount 1000 --externalAmount 1000


echo "Query specific pool"
sleep 8
furynd query clp pool catk

echo "adding new liquidity provider"
sleep 8
yes Y | furynd tx clp add-liquidity --from shadowfiend --symbol catk --nativeAmount 10000 --externalAmount 10000

echo "Query 1st Liquidity Provider / Pool creator is the first lp for the pool"
sleep 8
furynd query clp lp catk $(furynd keys show akasha -a)

echo "Query 2nd Liquidity Provider "
sleep 8
furynd query clp lp catk $(furynd keys show shadowfiend -a)


pkill furynd



furynd export >> state.json


if !  grep -q cbtk state.json; then
  echo "not found test fail"
fi

if !  grep -q catk state.json; then
  echo "not found test fail"
fi

rm -rf furynode.log
rm -rf state.json