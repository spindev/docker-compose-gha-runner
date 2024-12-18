#!/bin/bash

DOTENV_FILE=/actions-runner/.env

echo "Loading environment variables from ${DOTENV_FILE} file..."
if [ -f ${DOTENV_FILE} ]; then
    while IFS= read -r line; do
        # Skip comments and empty lines
        if [[ ! $line =~ ^# ]] && [[ -n $line ]]; then
            eval export "$line"
        fi
    done < ${DOTENV_FILE}
else
    echo "${DOTENV_FILE} file not found!"
    exit 1
fi

if [ -n "$HTTP_PROXY" ] || [ -n "$HTTPS_PROXY" ] || [ -n "$NO_PROXY" ]; then
    echo "Configuring Docker daemon with proxy settings..."
    mkdir -p /etc/docker
    cat <<EOF > /etc/docker/daemon.json
{
  "proxies": {
    "http-proxy": "$HTTP_PROXY",
    "https-proxy": "$HTTPS_PROXY",
    "no-proxy": "$NO_PROXY"
  }
}
EOF
fi

echo "Starting Docker daemon..."
dockerd &
DAEMON_PID=$!

cd /actions-runner || exit

echo "Allowing runner to run as root..."
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
./run.sh --once

echo "Stopping Docker daemon..."
kill $DAEMON_PID && wait $DAEMON_PID