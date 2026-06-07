# Repository Guidelines

## Project Structure & Module Organization

This repository stores standalone Docker Compose definitions for local services. Most services live as root-level `*.yml` files, such as `postgres.yml`, `mysql.yml`, and `openwebui.yml`. Services needing supporting files use directories: `writefreely/` contains its Compose file, Dockerfile, config, and startup script, while `mongo-rs/` contains the replica-set Compose file and setup image sources. Shared configuration belongs under `config/`, for example `config/telegraf/` and `config/mosquitto/`. Runtime data must stay out of git; `volumes/` is ignored. For new stacks, prefer relative bind mounts under `./volumes/<service>/` or documented named volumes over user-specific absolute paths.

## Build, Test, and Development Commands

Use Docker Compose directly against the target file:

```sh
docker compose -f postgres.yml up -d
docker compose -f postgres.yml down
PORT=8080 USERNAME=admin PASSWORD=pass docker compose -f writefreely/docker-compose.yml up --build
docker compose -f mongo-rs/mongo-rs.yml config
```

`up -d` starts a service in the background. `down` stops that stack. `up --build` is needed when a stack includes a Dockerfile. `config` validates Compose without starting containers. Set required variables inline or in an untracked `.env` file.

## Coding Style & Naming Conventions

Write YAML with two-space indentation. Keep service names, file names, and container names lowercase and descriptive, normally matching the product name (`postgres.yml`, `nodered.yml`, `mongo-rs`). Prefer one stack per Compose file unless helper containers are required, as in `mongo-rs`. Keep host ports explicit and easy to scan. Put reusable config under `config/<service>/`.

## Testing Guidelines

There is no application test suite in this repository. Validate changes with:

```sh
docker compose -f <compose-file> config
docker compose -f <compose-file> up -d
docker compose -f <compose-file> logs
```

For services with local builds, run `up --build` at least once. Avoid committing generated runtime data, local secrets, or machine-specific volume contents.

## Commit & Pull Request Guidelines

Recent history uses short imperative commits such as `Add open-notebook`, `Add Jupyter`, and `Update esphome`. Follow that style: `Add <service>`, `Update <service>`, or `Fix <service> config`. Pull requests should describe the service changed, list required variables or host paths, mention exposed ports, and include the validation command used. Call out privileged containers, host device access, and Docker socket mounts explicitly.

## Security & Configuration Tips

Do not commit `.env` files, passwords, tokens, or private bind-mounted data. If a sample credential is necessary for local testing, keep it obvious and non-production, and document required overrides in the PR description. Treat `privileged: true` and `/var/run/docker.sock` mounts as sensitive changes.
