#!/bin/bash
source /opt/bash-utils/logger.sh

load_env_variables() {
    DOTENV_FILE=/actions-runner/.env
    INFO "Loading environment variables from ${DOTENV_FILE} file..."
    if [ -f ${DOTENV_FILE} ]; then
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            if [[ ! $key =~ ^# ]] && [[ -n $key ]]; then
                export "$key"="$value"
            fi
        done < ${DOTENV_FILE}
    else
        INFO "${DOTENV_FILE} file not found!"
        exit 1
    fi
}

load_env_variables

start-docker.sh
start-runner.sh