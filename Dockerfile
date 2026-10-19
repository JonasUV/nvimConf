FROM alpine:latest

RUN apk add --no-cache neovim fzf  bash ripgrep lazygit git curl gcc tree-sitter tree-sitter-cli unzip python3
RUN apk add --no-cache gcc make  stylua rustfmt go

# LSP-Server direkt im Image statt über Mason (Mason-Binaries laufen teils nicht auf musl)
RUN apk add --no-cache lua-language-server rust-analyzer clang-extra-tools py3-lsp-server gopls nil neocmakelsp nodejs npm
RUN npm install -g bash-language-server dockerfile-language-server-nodejs vscode-langservers-extracted && npm cache clean --force
# texlab gibt es nur für x86_64 als musl-Build
ARG TEXLAB_VERSION=v5.26.0
ARG MARKSMAN_VERSION=2026-02-08
RUN case "$(uname -m)" in \
      x86_64) \
        curl -fsSL "https://github.com/latex-lsp/texlab/releases/download/${TEXLAB_VERSION}/texlab-x86_64-alpine.tar.gz" | tar -xz -C /usr/local/bin texlab && \
        curl -fsSL -o /usr/local/bin/marksman "https://github.com/artempyanykh/marksman/releases/download/${MARKSMAN_VERSION}/marksman-linux-musl-x64" ;; \
      aarch64) \
        curl -fsSL -o /usr/local/bin/marksman "https://github.com/artempyanykh/marksman/releases/download/${MARKSMAN_VERSION}/marksman-linux-musl-arm64" ;; \
    esac && \
    chmod +x /usr/local/bin/marksman

WORKDIR /config
ENV XDG_CONFIG_HOME=/config
ENV NVIM_SYSTEM_LSP=1
RUN git clone https://github.com/JonasUV/nvimConf.git nvim
RUN nvim --headless +qa

ARG XDG_CONFIG_HOME=/config
VOLUME [ "/data" ]
WORKDIR /data
ENTRYPOINT ["nvim"]
