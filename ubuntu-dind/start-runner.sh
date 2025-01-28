#!/bin/bash
source /opt/bash-utils/logger.sh

DOTENV_FILE=/actions-runner/.env

configure_runner() {
    cd /actions-runner || exit

    INFO "Allowing runner to run as root..."
    export RUNNER_ALLOW_RUNASROOT="1"

    DATA_DIR="/actions-runner/data/$HOSTNAME"

    if [ -d "$DATA_DIR" ]; then
        INFO "Runner already exists, copying configuration files..."
        cp "$DATA_DIR/.credentials" "$DATA_DIR/.runner" "$DATA_DIR/.credentials_rsaparams" /actions-runner/
    else
        INFO "Creating runner data directory..."
        mkdir -p "$DATA_DIR"

        INFO "Runner does not exist, configuring..."
        ./config.sh \
            --url ${RUNNER_GITHUB_URL}/${RUNNER_ORG} \
            --token ${RUNNER_REG_TOKEN} \
            --name ${HOSTNAME} \
            --runnergroup ${RUNNER_GROUP} \
            --labels ${RUNNER_LABELS} \
            --unattended

        INFO "Backing up the configuration files..."
        cp /actions-runner/.credentials /actions-runner/.credentials_rsaparams /actions-runner/.runner "$DATA_DIR"
    fi
}

start_runner() {
    INFO "Starting the runner..."
    ./run.sh --once
}

configure_runner
start_runner