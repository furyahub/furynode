#!/bin/bash

basedir=$(dirname $0)
. $basedir/vagrantenv.sh

cp $SMART_CONTRACTS_DIR/.env ${datadir}/env
cp $TEST_INTEGRATION_DIR/vagrantenv.sh ${datadir}/vagrantenv.sh
( cd $SMART_CONTRACTS_DIR && npx truffle networks ) > ${datadir}/trufflenetworks.txt &
rsync --delete -a $GANACHE_DB_DIR/ ${datadir}/ganachedb/ &
$basedir/furynet_logs.sh vagrant/data/logs/* > ${datadir}/furytransactions.json &
$basedir/furynet_blocks.sh vagrant/data/logs/* > ${datadir}/furyblocks.json &

wait 

tar Ccfz $datadir datafiles.tar.gz .
cp datafiles.tar.gz datafiles.$(date +%m-%d-%H-%M-%S).tar.gz
