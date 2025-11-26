ARG VARIANT=latest
FROM oven/bun:${VARIANT}

RUN apt-get update \
  && apt-get -y install --no-install-recommends \
  ca-certificates \
  git \
  nano \
  vim-tiny \
  && apt-get auto-remove -y \
  && apt-get clean -y

WORKDIR /app

COPY package.json bun.lock* ./
RUN bun install

COPY . .

EXPOSE 443

CMD ["bun", "run", "src/index.ts"]