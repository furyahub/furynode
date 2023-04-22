#!/usr/bin/env bash


clibuilder()
{
   echo ""
   echo "Usage: $0 -u UpgradeName -c CurrentBinary -n NewBinary"
   echo -e "\t-u Name of the upgrade [Must match a handler defined in setup-handlers.go in NewBinary]"
   echo -e "\t-c Branch name for old binary (Upgrade From)"
   echo -e "\t-n Branch name for new binary (Upgrade To)"
   exit 1 # Exit script after printing help
}

while getopts "u:c:n:" opt
do
   case "$opt" in
      u ) UpgradeName="$OPTARG" ;;
      c ) CurrentBinary="$OPTARG" ;;
      n ) NewBinary="$OPTARG" ;;
      ? ) clibuilder ;; # Print cliBuilder in case parameter is non-existent
   esac
done

if [ -z "$UpgradeName" ] || [ -z "$CurrentBinary" ] || [ -z "$NewBinary" ]
then
   echo "Some or all of the parameters are empty";
   clibuilder
fi


export DAEMON_HOME=$HOME/.furynoded
export DAEMON_NAME=furynoded
export DAEMON_ALLOW_DOWNLOAD_BINARIES=true

make clean
rm -rf ~/.furynoded
rm -rf furynode.log

rm -rf $GOPATH/bin/furynoded
rm -rf $GOPATH/bin/old/furynoded
rm -rf $GOPATH/bin/new/furynoded

# Setup old binary and start chain
git checkout $CurrentBinary
make install
cp $GOPATH/bin/furynoded $GOPATH/bin/old/
furynoded init test --chain-id=localnet -o

echo "Generating deterministic account - fury"
echo "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" | furynoded keys add fury --recover --keyring-backend=test

echo "Generating deterministic account - akasha"
echo "hand inmate canvas head lunar naive increase recycle dog ecology inhale december wide bubble hockey dice worth gravity ketchup feed balance parent secret orchard" | furynoded keys add akasha --recover --keyring-backend=test


#furynoded keys add mkey --multisig fury,akasha --multisig-threshold 2 --keyring-backend=test

furynoded add-genesis-account $(furynoded keys show fury -a --keyring-backend=test) 500000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink,90000000000000000000ibc/96D7172B711F7F925DFC7579C6CCC3C80B762187215ABD082CDE99F81153DC80 --keyring-backend=test
furynoded add-genesis-account $(furynoded keys show akasha -a --keyring-backend=test) 500000000000000000000000fury,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test

#furynoded add-genesis-clp-admin $(furynoded keys show fury -a --keyring-backend=test) --keyring-backend=test
#furynoded add-genesis-clp-admin $(furynoded keys show akasha -a --keyring-backend=test) --keyring-backend=test

#furynoded set-genesis-whitelister-admin fury --keyring-backend=test

#furynoded add-genesis-validators $(furynoded keys show fury -a --bech val --keyring-backend=test) --keyring-backend=test

furynoded gentx fury 1000000000000000000000000stake --chain-id=localnet --keyring-backend=test

echo "Collecting genesis txs..."
furynoded collect-gentxs

echo "Validating genesis file..."
furynoded validate-genesis


mkdir -p $DAEMON_HOME/cosmovisor/genesis/bin
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/$UpgradeName/bin


# Setup new binary
git checkout $NewBinary
rm -rf $GOPATH/bin/furynoded
make install
cp $GOPATH/bin/furynoded $GOPATH/bin/new/


# Setup cosmovisor
cp $GOPATH/bin/old/furynoded $DAEMON_HOME/cosmovisor/genesis/bin
cp $GOPATH/bin/new/furynoded $DAEMON_HOME/cosmovisor/upgrades/$UpgradeName/bin/

chmod +x $DAEMON_HOME/cosmovisor/genesis/bin/furynoded
chmod +x $DAEMON_HOME/cosmovisor/upgrades/$UpgradeName/bin/furynoded

contents="$(jq '.app_state.gov.voting_params.voting_period = "10s"' $DAEMON_HOME/config/genesis.json)" && \
echo "${contents}" > $DAEMON_HOME/config/genesis.json

# Add state data here if required

cosmovisor start --home ~/.furynoded/ --p2p.laddr 0.0.0.0:27655  --grpc.address 0.0.0.0:9096 --grpc-web.address 0.0.0.0:9093 --address tcp://0.0.0.0:27659 --rpc.laddr tcp://127.0.0.1:26657 >> furynode.log 2>&1  &
#sleep 7
#furynoded tx tokenregistry register-all /Users/tanmay/Documents/furynode/scripts/ibc/tokenregistration/localnet/fury.json --from fury --keyring-backend=test --chain-id=localnet --yes
sleep 7
furynoded tx gov submit-proposal software-upgrade $UpgradeName --from fury --deposit 100000000stake --upgrade-height 10 --title $UpgradeName --description $UpgradeName --keyring-backend test --chain-id localnet --yes
sleep 7
furynoded tx gov vote 1 yes --from fury --keyring-backend test --chain-id localnet --yes
clear
sleep 7
furynoded query gov proposal 1

tail -f furynode.log

#yes Y | furynoded tx gov submit-proposal software-upgrade 0.9.14 --from fury --deposit 100000000stake --upgrade-height 30 --title 0.9.14 --description 0.9.14 --keyring-backend test --chain-id localnet