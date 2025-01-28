FROM ubuntu:noble

# Tag Versions
ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=27.3.1 \
    DOCKER_COMPOSE_VERSION=v2.29.6 \
    BUILDX_VERSION=v0.17.1 \
    DEBUG=false \
    RUNNER_VERSION=2.321.0 \
    DEBIAN_FRONTEND=noninteractive 

# Install Common Dependencies
RUN set -eux; \
    apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    iptables \
    jq \
    libffi-dev \
    libssl-dev \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    ssh \
    supervisor \
    tree \
    wget \
    && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates

# Install Docker, Compose and Buildx
RUN set -eux; \
    update-alternatives --set iptables /usr/sbin/iptables-legacy; \
    arch="$(uname -m)"; \
    case "$arch" in \
    x86_64) dockerArch='x86_64' ; buildx_arch='linux-amd64' ;; \
    armhf) dockerArch='armel' ; buildx_arch='linux-arm-v6' ;; \
    armv7) dockerArch='armhf' ; buildx_arch='linux-arm-v7' ;; \
    aarch64) dockerArch='aarch64' ; buildx_arch='linux-arm64' ;; \
    *) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;; \
    esac && \
    wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz" && \
    tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin/ && \
    rm docker.tgz && \
    wget -O docker-buildx "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.${buildx_arch}" && \
    mkdir -p /usr/local/lib/docker/cli-plugins && \
    chmod +x docker-buildx && \
    mv docker-buildx /usr/local/lib/docker/cli-plugins/docker-buildx && \
    dockerd --version && \
    docker --version && \
    docker buildx version && \
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose version && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# Setup GitHub Actions Runner
RUN mkdir -p /actions-runner/data && \
    cd /actions-runner && \
    curl -o "actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" && \
    tar xzf "actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" && \
    rm -rf "actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" && \
    /actions-runner/bin/installdependencies.sh

# Setup Scripts
COPY modprobe start-docker.sh start-runner.sh entrypoint.sh /usr/local/bin/
COPY dockerd.conf /etc/supervisor/conf.d/
COPY logger.sh /opt/bash-utils/logger.sh
RUN chmod +x \
    /usr/local/bin/modprobe \
    /usr/local/bin/start-docker.sh \
    /usr/local/bin/start-runner.sh \
    /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]