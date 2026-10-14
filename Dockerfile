FROM ghcr.io/actions/actions-runner:2.338.0

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        gh \
        libgl1 \
        libglib2.0-0t64 \
        perl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:0.13.1 /uv /uvx /usr/local/bin/

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --no-modify-path --profile minimal \
            --component clippy,rustfmt --default-toolchain stable \
    && chmod -R a+w "$RUSTUP_HOME" "$CARGO_HOME"

USER runner
