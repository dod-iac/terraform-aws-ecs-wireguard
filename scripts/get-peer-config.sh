#! /usr/bin/env bash

#
# Print the config file for the peer you want to connect with
# PEER is 1-indexed, not 0-indexed
#

set -eu -o pipefail

if [ "$#" -ne 1 ]; then
    echo "You must enter exactly 1 command line arguments"
fi

PEER=$1

CLUSTER=wireguard
CONTAINER=wireguard
TASK_ID=$(aws ecs list-tasks --cluster "${CLUSTER}" | jq -r .taskArns[0] | cut -d "/" -f3)

aws ecs execute-command --cluster "${CLUSTER}" --task "${TASK_ID}"  --container "${CONTAINER}" --command "cat config/peer${PEER}/peer${PEER}.conf" --interactive
