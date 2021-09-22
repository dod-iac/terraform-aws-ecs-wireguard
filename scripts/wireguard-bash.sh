#! /usr/bin/env bash

#
# Sets up an interactive bash prompt into the wireguard container
#

set -eu -o pipefail

CLUSTER=wireguard
CONTAINER=wireguard
TASK_ID=$(aws ecs list-tasks --cluster "${CLUSTER}" | jq -r .taskArns[0] | cut -d "/" -f3)

aws ecs execute-command --cluster "${CLUSTER}" --task "${TASK_ID}"  --container "${CONTAINER}" --command "/bin/bash" --interactive
