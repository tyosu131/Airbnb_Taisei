# Airbnb_Taisei

Rails 6 based Airbnb-style application.

This repository is currently being modernized from an older learning project into a portfolio-grade Rails application. The first recovery step is to make the application boot reproducibly with Docker on Apple Silicon.

## Tech Stack

- Ruby 3.0.3
- Rails 6.0.4.7
- MySQL 5.7
- Devise
- Active Storage
- Webpacker
- Docker Compose

## Local Development with Docker

### Prerequisites

- Docker Desktop
- Git

For Apple Silicon Macs, the current Docker setup runs both the Rails app and MySQL as linux/amd64 because the legacy MySQL 5.7 and old frontend dependencies are not arm64-friendly.

### Start the application

Run:

    docker compose up --build

The Rails app is exposed at:

    http://localhost:3002

### Initial database setup

In another terminal, run:

    docker compose exec web rails db:create db:migrate

If exec fails because the container is not running, use:

    docker compose run --rm web rails db:create db:migrate

Then open:

    http://localhost:3002

### Stop containers

Run:

    docker compose down

## Current Docker Notes

The Docker setup includes:

- platform linux/amd64 for MySQL 5.7 on Apple Silicon
- platform linux/amd64 for the Rails web container to avoid old node-sass arm64 build failures
- Bundler 2.3.9 to match Gemfile.lock
- Yarn installed through a keyring-based apt source instead of deprecated apt-key
- A named node_modules volume so the bind mount does not hide container-installed frontend packages
- .dockerignore to keep local data and dependencies out of Docker build context

## Known Local Issues

Docker Desktop may crash on some Apple Silicon environments due to Docker Desktop / virtualization.framework issues. If that happens after a successful build and boot, restart Docker Desktop or reboot macOS.

The current Docker setup is a recovery step, not the final production architecture. Later modernization work should consider:

- Replacing MySQL 5.7
- Moving to PostgreSQL or a supported MySQL version
- Upgrading Ruby and Rails
- Replacing legacy Webpacker / node-sass dependencies
- Adding CI, tests, and security checks

## Verified Recovery Status

The following has been verified locally:

- Docker image builds successfully
- Rails boots in development
- MySQL container starts
- rails db:create db:migrate completes
- Top page renders at http://localhost:3002

## Next Modernization Targets

- Clean up routes
- Fix authorization around property and image management
- Separate public property browsing from host listing management
- Add model validations and database constraints
- Add reservation domain model
- Add CI and security checks
- Upgrade Ruby / Rails in controlled steps
