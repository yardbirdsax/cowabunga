FROM ghcr.io/charmbracelet/gum:v0.6.0 as gum
FROM hairyhenderson/gomplate:1.9.1-slim as gomplate


FROM alpine:3.16

ARG GH_CLI_VERSION=2.15.0

LABEL "maintainer"="Josh Feierman <josh@sqljosh.com>" \
      "repository"="https://github.com/yardbirdsax/cowabunga" \
      "homepage"="https://github.com/yardbirdsax/cowabunga" \
      "org.opencontainers.image.title"="cowabunga" \
      "org.opencontainers.image.description"="A Docker image with lots of shell goodies" \
      "org.opencontainers.image.url"="https://github.com/yardbirdsax/cowabunga" \
      "org.opencontainers.image.source"="https://github.com/yardbirdsax/cowabunga"

RUN apk add --no-cache yq jq git bash curl openssl libc6-compat
RUN curl -Lo /tmp/ghcli.tar.gz https://github.com/cli/cli/releases/download/v${GH_CLI_VERSION}/gh_${GH_CLI_VERSION}_linux_amd64.tar.gz
RUN tar xzf /tmp/ghcli.tar.gz -C /tmp/ && \
    mv /tmp/gh_${GH_CLI_VERSION}_linux_amd64/bin/gh /usr/local/bin/
RUN curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
RUN tgswitch 0.38.12
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git $HOME/.tfenv && \
    ln -s $HOME/.tfenv/bin/terraform /usr/local/bin/terraform && \
    ln -s $HOME/.tfenv/bin/tfenv /usr/local/bin/tfenv
RUN tfenv install latest
RUN tfenv use latest
COPY --from=gum /usr/local/bin/gum /usr/local/bin/gum
COPY --from=gomplate /gomplate /usr/local/bin/gomplate
ENTRYPOINT [ "/bin/bash" ]
