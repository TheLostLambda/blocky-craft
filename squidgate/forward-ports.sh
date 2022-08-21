#!/usr/bin/env bash

SERVER='root@bitfield.xyz'
LOCAL_PORTS=(25565)
REMOTE_PORTS=(25565)
SSH_PIDS=()

for I in ${!LOCAL_PORTS[@]}
do
  while true
  do
    echo "Forwarding ${LOCAL_PORTS[$I]} to $SERVER:${REMOTE_PORTS[$I]}..."
    ssh -ttR ${REMOTE_PORTS[$I]}:127.0.0.1:${LOCAL_PORTS[$I]} $SERVER -o ExitOnForwardFailure=yes
    sleep 1
  done &
  SSH_PIDS+=($!)
done

function cleanup {
  pkill -P $$
  for I in "${SSH_PIDS[@]}"
  do
    echo "Stopping $I..."
    pkill -P "$I"
  done
  echo "All tunnels closed!"
}
trap cleanup EXIT

echo "All port-forwarding threads launched"
wait $!

