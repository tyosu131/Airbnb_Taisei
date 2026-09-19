# Taibnb: a recovered Rails learning project

Taibnb is a deliberately compact property-listing and reservation application. It began as a 2022 Rails learning project and, after gaining professional backend engineering experience, was revisited in 2026. The existing application was incrementally recovered, secured, tested, and modernized as evidence of practical Rails work—not as an attempt to reproduce all of Airbnb.

## What it demonstrates

- Devise registration, sessions, password recovery, and authenticated routes.
- Public browsing of published properties, with host-only listing and image management.
- Active Record associations across `User`, `Property`, `Image`, and `Reservation`.
- Draft-versus-published property validation and validated Active Storage image types.
- Reservation rules for future dates, positive stay lengths, host/guest separation, derived prices, and non-overlapping stays.
- Ownership-based authorization using records scoped through `current_user` rather than trusting submitted IDs.
- Database foreign keys, non-null columns, and indexes that support the model invariants and availability query.
- Focused model and request tests, plus Docker-based CI and a Brakeman scan.

## Domain model

```text
User (host) 1 ─── * Property 1 ─── * Image
     (guest) 1 ─── * Reservation * ─── 1 Property
```

A property may remain an incomplete draft, but it cannot be published until its public fields and a positive nightly price are present. A reservation treats checkout as an exclusive boundary, so one guest may check in on another guest's checkout date. Its total is always recalculated as `nights × property.price`; the controller does not permit a client-supplied guest or price.

The create path locks the property while checking and inserting a reservation. That keeps the simple overlap validation useful under concurrent requests without introducing a larger booking architecture. It is appropriate for this project's scope; a high-volume system would use a database-native range exclusion constraint or a dedicated inventory model.

## Stack

- Ruby 3.3.8 and Rails 6.0.4.7
- MySQL 8.0
- Devise and Active Storage
- Webpacker/Turbolinks with Bootstrap 4
- Minitest request and model tests
- Docker Compose and GitHub Actions

The Rails/frontend versions are intentionally recorded rather than presented as current. Ruby uses the supported 3.3 series on Debian Bookworm so OS packages no longer depend on Bullseye's retired repositories. Webpacker 4 still pins node-sass 4, so the image copies the exact Node 14/Yarn Classic runtime from its official image instead of installing packages from archived apt mirrors. Node 14 is also end-of-life; this explicit compatibility stage is a short-term maintenance trade-off, not a claim that the frontend is current. Moving the application to a supported Rails/frontend toolchain is deliberately outside this focused recovery. Compose targets `linux/amd64` because this node-sass release has no native arm64 build, so Docker Desktop uses emulation on Apple Silicon until that stack is replaced.

## Run locally with Docker

Prerequisites: Docker Desktop (or Docker Engine with Compose) and Git.

```bash
git clone https://github.com/tyosu131/Airbnb_Taisei.git
cd Airbnb_Taisei
docker compose build web
docker compose run --rm web bundle exec rails db:prepare
docker compose up
```

Open <http://localhost:3002>. The database data is stored under the ignored `data/` directory. Compose waits for MySQL's health check before starting one-off web commands.
All environments use the MySQL adapter; production expects a MySQL `DATABASE_URL`.

Run the suite and inspect the application:

```bash
docker compose run --rm -e RAILS_ENV=test web bundle exec rails db:prepare
docker compose run --rm -e RAILS_ENV=test web bundle exec rails test
docker compose run --rm web bundle exec rails routes
docker compose run --rm web bundle exec rails runner 'puts Rails.application.class.name'
```

## Quality and security

The GitHub Actions workflow rebuilds the same Docker image used locally, prepares a clean test database, runs all model/request tests, checks Ruby syntax and RuboCop lint rules, boots Rails, loads the route set, and runs the repository's Brakeman security gate. Run the same gate locally with:

```bash
docker compose run --rm web bundle exec ruby bin/brakeman_gate.rb
```

The gate still performs a raw Brakeman scan. It explicitly accepts only the known Rails 6 end-of-life warning as a legacy limitation; every other Brakeman warning remains blocking.

## Verified modernization state

The completed modernization was verified with the following evidence:

- the Docker image builds successfully;
- test database preparation and migrations succeed;
- the Rails suite completes with 16 runs, 50 assertions, 0 failures, 0 errors, and 0 skips;
- the Ruby syntax check and RuboCop lint pass;
- the Rails application boots and its routes load successfully;
- the repository security gate passes; and
- the final `develop` GitHub Actions run after merge is green.

## Recovery and modernization decisions

The recovery retained the recognizable Rails application and improved it incrementally:

- separated public property browsing from the authenticated `Host` namespace;
- scopes property and image mutations through the signed-in host;
- corrected the legacy `has_air_condtion` database column via migration;
- moved Docker from end-of-life MySQL 5.7 to MySQL 8.0 and added readiness checks;
- added missing foreign keys, type-compatible references, non-null constraints, and query indexes;
- added the reservation domain and tests around plausible security and business-rule regressions;
- expanded CI beyond syntax checks into a meaningful test and security gate.

## Known limitations and excluded scope

- Rails 6.0 is end-of-life and remains an explicitly accepted legacy limitation. Webpacker, Turbolinks, and the Node 14 compatibility stack also remain legacy; replacing them is intentionally outside the bounded modernization scope.
- Prices are whole currency units; taxes, fees, currencies, payments, refunds, and booking statuses are intentionally absent.
- A PostgreSQL exclusion constraint is not used because the application standardizes on MySQL. Overlap prevention uses application validation while holding a property row lock on the web create path.
- Image files use local disk storage by default. Production object storage is not configured.
- There is no chat, maps integration, realtime inventory, or deployment infrastructure. Those features would add size without improving the intended Rails evidence.
