# Docker Compose Runner

This project uses Docker Compose to manage scaled GitHub self-hosted Runner instances.

## Prerequisites

- Docker
- Docker Compose

## Usage

### Ubuntu

- Make sure you adjust the `ubuntu/.env` file to your needs.

- To start the runners in the `ubuntu` directory, adjust the `ubuntu/docker-compose.yml` file to your needs and run the following command:

  ```sh
  docker-compose -f ubuntu/docker-compose.yml up -d --build
  ```

- To stop the runners in the `ubuntu` directory:
  ```sh
  docker-compose -f ubuntu/docker-compose.yml down
  ```

### Ubuntu-Dind

- Make sure you adjust the `ubuntu-dind/.env` file to your needs.

- To start the runners in the `ubuntu-dind` directory, adjust the `ubuntu-dind/docker-compose.yml` file to your needs and run the following command:

  ```sh
  docker-compose -f ubuntu-dind/docker-compose.yml up -d --build
  ```

- To stop the runners in the `ubuntu-dind` directory:
  ```sh
  docker-compose -f ubuntu-dind/docker-compose.yml down
  ```
