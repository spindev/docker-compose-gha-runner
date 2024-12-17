#!/bin/bash

GITHUB_URL=$GITHUB_URL
ORG=$ORG
REG_TOKEN=$REG_TOKEN
LABELS=$LABELS
RUNNERGROUP=$RUNNERGROUP

echo "Starting docker daemon..."
dockerd &

cd /actions-runner || exit

export RUNNER_ALLOW_RUNASROOT="1"

DATA_DIR="/actions-runner/data/$HOSTNAME"

if [ -d "$DATA_DIR" ]; then
    echo "Runner already exists, copying configuration files..."
    cp "$DATA_DIR/.credentials" "$DATA_DIR/.runner" "$DATA_DIR/.credentials_rsaparams" /actions-runner/
else
    echo "Creating runner data directory..."
    mkdir -p "$DATA_DIR"

    echo "Runner does not exist, configuring..."
    ./config.sh --url ${GITHUB_URL}/${ORG} --token ${REG_TOKEN} --name ${HOSTNAME} --runnergroup $RUNNERGROUP --labels $LABELS

    echo "Backing up the configuration files..."
    cp /actions-runner/.credentials /actions-runner/.credentials_rsaparams /actions-runner/.runner "$DATA_DIR"
fi

echo "Starting the runner..."
./run.sh --once & wait $!