# start from a base image
FROM ubuntu:noble

# Runner installation
ARG RUNNER_VERSION="2.321.0"
ARG DEBIAN_FRONTEND=noninteractive

# Copy the start script
COPY start.sh /start.sh

# setup docker & runner
RUN apt-get update && \
    apt-get upgrade -y && \
    # Install necessary packages
    apt-get install -y \
    ca-certificates \
    curl \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    jq \
    ssh && \
    # Setup Docker repository
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    # Install Docker
    apt-get install -yqq --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/* && \
    # Setup GitHub Actions runner
    mkdir -p /actions-runner/data && \
    cd /actions-runner && \
    curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    /actions-runner/bin/installdependencies.sh && \
    chmod +x /start.sh

# Define the entrypoint
ENTRYPOINT ["/start.sh"]