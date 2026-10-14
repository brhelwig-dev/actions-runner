FROM ghcr.io/actions/actions-runner:2.338.0

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        gh \
        libgl1 \
        libglib2.0-0t64 \
        perl \
        sqlite3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:0.13.1 /uv /uvx /usr/local/bin/
COPY --from=oven/bun:1.4.3-debian /usr/local/bin/bun /usr/local/bin/bun
COPY --from=golang:1.27.2-bookworm /usr/local/go /usr/local/go

RUN ln -s bun /usr/local/bin/bunx

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/go/bin:/usr/local/cargo/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --no-modify-path --profile minimal \
            --component clippy,rustfmt --default-toolchain stable \
    && chmod -R a+w "$RUSTUP_HOME" "$CARGO_HOME"

USER runner
