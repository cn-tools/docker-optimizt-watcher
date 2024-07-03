# special thx to https://github.com/343dev
# based on https://github.com/343dev/optimizt/issues/4

FROM node:18.20.3-bullseye-slim

WORKDIR /app

ENV NODE_ENV="production"
ENV SHELL="/bin/bash"

RUN apt update \
  && apt install --yes --no-install-recommends build-essential libpng16-16 libjpeg62-turbo libjpeg62-turbo-dev libpng-dev pkg-config dh-autoreconf \
  && npm install --global @343dev/optimizt chokidar-cli \
  && npm cache clean --force \
  && apt purge --yes build-essential pkg-config libpng-dev libjpeg62-turbo-dev dh-autoreconf \
  && apt autoremove --yes --purge \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

WORKDIR /src

CMD chokidar "/src/input/**/*" \
  --command "if [ '{event}' = 'add' ]; then optimizt --verbose /src/input && mv /src/input/* /src/output; fi;" \
  --polling \
  --verbose
