FROM ghcr.io/actions/actions-runner:2.338.2

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        gh \
        libarchive-tools \
        libgl1 \
        libglib2.0-0t64 \
        nodejs \
        perl \
        sqlite3 \
        xz-utils \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:0.13.1 /uv /uvx /usr/local/bin/
COPY --from=oven/bun:1.4.3-debian /usr/local/bin/bun /usr/local/bin/bun
COPY --from=golang:1.27.2-bookworm /usr/local/go /usr/local/go

RUN ln -s bun /usr/local/bin/bunx

RUN curl -fsSLo /tmp/zig.tar.xz https://ziglang.org/download/0.17.0/zig-aarch64-linux-0.17.0.tar.xz \
    && echo "9e8d11661d4ae3bd57702a3832781e23ad151dde5798e16a5ccd503f65234ff8  /tmp/zig.tar.xz" | sha256sum -c - \
    && mkdir /usr/local/zig \
    && tar -xJf /tmp/zig.tar.xz -C /usr/local/zig --strip-components 1 \
    && rm /tmp/zig.tar.xz

RUN curl -fsSLo /tmp/helm.tar.gz https://get.helm.sh/helm-v4.3.1-linux-arm64.tar.gz \
    && echo "8cf8f66ecbc252ac8f7f06cca68aba88508ddfde3a6a34feb1678ad1694b4f88  /tmp/helm.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/helm.tar.gz -C /usr/local/bin --strip-components 1 linux-arm64/helm \
    && rm /tmp/helm.tar.gz

RUN curl -fsSLo /tmp/sccache.tar.gz https://github.com/mozilla/sccache/releases/download/v0.18.0/sccache-v0.18.0-aarch64-unknown-linux-musl.tar.gz \
    && echo "2b3284d5da3b46a47dc4229e75bb7b88ac4aa99c8d754fb7d2f84997e5a4354a  /tmp/sccache.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/sccache.tar.gz -C /usr/local/bin --strip-components 1 sccache-v0.18.0-aarch64-unknown-linux-musl/sccache \
    && rm /tmp/sccache.tar.gz

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/go/bin:/usr/local/zig:/usr/local/cargo/bin:$PATH

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --no-modify-path --profile minimal \
            --component clippy,rustfmt --default-toolchain stable \
    && chmod -R a+w "$RUSTUP_HOME" "$CARGO_HOME"

USER runner
