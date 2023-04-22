#!/bin/bash

killall furynoded

rm $(which furynoded) 2> /dev/null || echo furynoded not install yet ...

rm -rf ~/.furynoded

cd ../../../ && make install 