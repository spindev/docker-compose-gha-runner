# Docker Compose Runner

This project uses Docker Compose to manage scaled GitHub self-hosted Runner instances.

## Prerequisites

- Docker
- Docker Compose

## Usage

### Setup

1. Clone the repository:

```sh
git clone https://github.com/yourusername/docker-compose-gha-runner.git
cd docker-compose-gha-runner
```

2. Edit the `.env` file and set the required environment variables:

```properties
RUNNER_GITHUB_URL=https://github.com
RUNNER_ORG=<org>
RUNNER_LABELS=<labels>
RUNNER_REG_TOKEN=<REG_TOKEN>
RUNNER_GROUP=<RUNNERGROUP>
```

3. Start the Docker Compose services:

```sh
docker-compose up -d
```

4. Verify that the runners are registered and active in your GitHub organization.

### Stopping the Runners

To stop the runners, run:

```sh
docker-compose down
```
