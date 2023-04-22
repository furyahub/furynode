#!/usr/bin/env bash

echo "Creating pools ceth and cdash"
furynd tx clp create-pool --from fury --symbol ceth --nativeAmount 20000000000000000000 --externalAmount 20000000000000000000  --yes

sleep 5
furynd tx clp create-pool --from fury --symbol cdash --nativeAmount 20000000000000000000 --externalAmount 20000000000000000000  --yes


sleep 8
echo "Swap Native for Pegged - Sent fury Get ceth"
furynd tx clp swap --from fury --sentSymbol fury --receivedSymbol ceth --sentAmount 2000000000000000000 --minReceivingAmount 0 --yes
sleep 8
echo "Swap Pegged for Native - Sent ceth Get fury"
furynd tx clp swap --from fury --sentSymbol ceth --receivedSymbol fury --sentAmount 2000000000000000000 --minReceivingAmount 0 --yes
sleep 8
echo "Swap Pegged for Pegged - Sent ceth Get cdash"
furynd tx clp swap --from fury --sentSymbol ceth --receivedSymbol cdash --sentAmount 2000000000000000000 --minReceivingAmount 0 --yes

furynd q clp pools

