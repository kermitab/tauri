FROM node:19-bullseye

# webkit2gtk
RUN apt update && apt install -y \
    libwebkit2gtk-4.0-dev \
    build-essential \
    curl \
    wget \
    libssl-dev \
    libgtk-3-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev \
    vim \
  && apt clean && rm -rf /var/lib/apt/lists/*

# Rust
USER node
ENV HOME /home/node
ENV PATH=$PATH:${HOME}/.cargo/bin

RUN mkdir -p ${HOME}/.cargo/bin \
  && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o ${HOME}/.cargo/rustup.sh \
  && sh ${HOME}/.cargo/rustup.sh -y --default-toolchain nightly --no-modify-path \
  && cargo install create-tauri-app

# frontend Leptos
RUN cargo install tauri-cli trunk \
  && rustup target add wasm32-unknown-unknown

WORKDIR /workspace

CMD ["bash"]