#!/usr/bin/env bash

echo "Creating pools ceth and cdash"
furynoded tx clp create-pool --from fury --symbol ceth --nativeAmount 20000000000000000000 --externalAmount 20000000000000000000  --yes

sleep 5
furynoded tx clp create-pool --from fury --symbol cdash --nativeAmount 20000000000000000000 --externalAmount 20000000000000000000  --yes


sleep 8
echo "Swap Native for Pegged - Sent fury Get ceth"
furynoded tx clp swap --from fury --sentSymbol fury --receivedSymbol ceth --sentAmount 2000000000000000000 --minReceivingAmount 0 --yes
sleep 8
echo "Swap Pegged for Native - Sent ceth Get fury"
furynoded tx clp swap --from fury --sentSymbol ceth --receivedSymbol fury --sentAmount 2000000000000000000 --minReceivingAmount 0 --yes
sleep 8
echo "Swap Pegged for Pegged - Sent ceth Get cdash"
furynoded tx clp swap --from fury --sentSymbol ceth --receivedSymbol cdash --sentAmount 2000000000000000000 --minReceivingAmount 0 --yes

furynoded q clp pools

