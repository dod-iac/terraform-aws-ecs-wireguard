#! /usr/bin/env bash

#
# Print the QR code for the peer you want to connect with
# PEER is 1-indexed, not 0-indexed
#

set -eu -o pipefail

CLUSTER=wireguard
CONTAINER=wireguard
TASK_ID=$(aws ecs list-tasks --cluster "${CLUSTER}" | jq -r .taskArns[0] | cut -d "/" -f3)

aws ecs execute-command --cluster "${CLUSTER}" --task "${TASK_ID}"  --container "${CONTAINER}" --command "/app/show-peer $*" --interactive
