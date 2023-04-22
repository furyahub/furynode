#!/bin/bash
pid_furynode=$(ps aux | grep "furynoded start" | grep -v grep | awk '{print $2}')
# pid_rest=$(ps aux | grep "furynoded rest-server" | grep -v grep | awk '{print $2}')

if [[ ! -z "$pid_furynode" ]]; then 
  kill -9 $pid_furynode
fi

# if [[ ! -z "$pid_rest" ]]; then 
#   kill -9 $pid_rest
# fi