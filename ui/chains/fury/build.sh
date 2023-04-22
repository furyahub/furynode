#!/bin/bash

killall furynd

rm $(which furynd) 2> /dev/null || echo furynd not install yet ...

rm -rf ~/.furynd

cd ../../../ && make install 