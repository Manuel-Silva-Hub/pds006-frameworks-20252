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

# ESTO FALTA - Copiar archivos y instalar dependencias
COPY package.json bun.lock* ./
RUN bun install

# Copiar el código
COPY . .

# Exponer puerto
EXPOSE 3000

# ESTO FALTA - Comando para iniciar
CMD ["bun", "run", "src/index.ts"]