FROM alpine:latest

RUN apk add --no-cache neovim fzf  bash ripgrep lazygit git curl gcc tree-sitter unzip python3
RUN apk add --no-cache gcc make  stylua rustfmt go

WORKDIR /config
ENV XDG_CONFIG_HOME=/config
RUN git clone https://github.com/JonasUV/nvimConf.git nvim
RUN nvim --headless '+Lazy install' +qall

ARG XDG_CONFIG_HOME=/config
VOLUME [ "/data" ]
WORKDIR /data
ENTRYPOINT ["nvim"]
