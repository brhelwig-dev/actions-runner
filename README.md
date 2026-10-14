# actions-runner

The [GitHub Actions runner image](https://github.com/actions/runner/pkgs/container/actions-runner)
with extra build tools, for self-hosted runners on arm64 Linux.

```
ghcr.io/brhelwig-dev/actions-runner:latest
```

## What it adds

| Tool | Source |
|---|---|
| `build-essential`, `gh`, `libgl1`, `libglib2.0-0t64`, `perl`, `sqlite3` | Ubuntu packages |
| `uv`, `uvx` | [`ghcr.io/astral-sh/uv`](https://github.com/astral-sh/uv) |
| `bun`, `bunx` | [`oven/bun`](https://hub.docker.com/r/oven/bun) |
| `go` | [`golang`](https://hub.docker.com/_/golang) |
| Rust stable with `clippy` and `rustfmt` | [rustup](https://rustup.rs), in `/usr/local/cargo` and `/usr/local/rustup` |

The upstream image already has the runner, `git`, `curl`, `jq`, the Docker CLI and buildx.
Mount a Docker socket into the container to build images.

To add an Ubuntu package, add it to the sorted list in the [`Dockerfile`](Dockerfile).

## Builds

The [workflow](.github/workflows/build.yml) builds the image on every push and pull request,
and pushes `latest` from `main` and once a day. The daily build picks up new Ubuntu packages
and Rust stable. The runner, `uv`, `bun` and `go` images are pinned in the `Dockerfile`, and
[Dependabot](.github/dependabot.yml) opens a weekly pull request when one has a new release.
