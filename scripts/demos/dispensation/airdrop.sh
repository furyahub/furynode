


# Multisig Key - It is a key composed of two or more keys (N) , with a signing threshold (K) ,such that the transaction needs K out of N votes to go through.

# create airdrop
# mkey = multisig key
# ar1 = name for airdrop , needs to be unique for every airdrop . If not the tx gets rejected
# input.json list of funding addresses  -  Input address must be part of the multisig key
# output.json list of airdrop receivers.
furynd tx dispensation create ValidatorSubsidy output.json fury1syavy2npfyt9tcncdtsdzf7kny9lh777yqc2nd --from fury1syavy2npfyt9tcncdtsdzf7kny9lh777yqc2nd --yes --fees 150000fury --chain-id=localnet --keyring-backend=test
furynd tx dispensation run 29_fury1syavy2npfyt9tcncdtsdzf7kny9lh777yqc2nd ValidatorSubsidy--from fury1syavy2npfyt9tcncdtsdzf7kny9lh777yqc2nd --yes --fees 150000fury --chain-id=localnet --keyring-backend=test
sleep 8
furynd q dispensation distributions-all -chain-id localnet
#furynd q dispensation records-by-name-all ar1 >> all.json
#furynd q dispensation records-by-name-pending ar1 >> pending.json
#furynd q dispensation records-by-name-completed ar1 >> completed.json
#furynd q dispensation records-by-addr fury1cp23ye3h49nl5ty35vewrtvsgwnuczt03jwg00

furynd tx dispensation create Airdrop output.json --gas 90128 --from $(furynd keys show fury -a) --yes --broadcast-mode async --sequence 26 --account-number 3 --chain-id localnet
furynd tx dispensation create Airdrop output.json --gas 90128 --from $(furynd keys show fury -a) --yes --broadcast-mode async --sequence 27 --account-number 3 --chain-id localnet
furynd tx dispensation run 25_fury1syavy2npfyt9tcncdtsdzf7kny9lh777yqc2nd ValidatorSubsidy --from fury1syavy2npfyt9tcncdtsdzf7kny9lh777yqc2nd --yes --gas auto --gas-adjustment=1.5 --gas-prices 1.0fury --chain-id=localnet --keyring-backend=test



