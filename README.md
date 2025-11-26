# Practicas/Metricas aplicadas a lo largo del proyecto

- Arquitectura hexagonal

- Nombramiento de archivos con `kebab-case` y extensión descriptiva (ej. `usuario.entidad.ts` o `postgres.repository.ts`)

- Uso *minimo* de primitivos en las clases de dominio [articulo relacionado](https://medium.com/better-programming/why-you-should-avoid-using-primitive-types-cb55857baa39)

- Exportación conjunta en módulos utilizando `barrel exports` [articulo relacionado](https://alirezahamid.medium.com/simplify-your-javascript-and-typescript-projects-with-barrel-exports-20b73680cbfe)

- Manejo de errores con clases definidas a partir de clase utilitaria `BaseError` [articulo relacionado](https://engineering.udacity.com/handling-errors-like-a-pro-in-typescript-d7a314ad4991)

- Nombramiento de funciones y variables siguiendo practicas Clean-Code

# Elysia with Bun runtime

## Getting Started
To get started with this template, simply paste this command into your terminal:
```bash
bun create elysia ./elysia-example
```

## Development
To start the development server run:
```bash
bun run dev
```

Open http://localhost:443/ with your browser to see the result.


# Tecnologías:
-Runtime: Bun - JavaScript runtime ultrarrápido
-Observabilidad: Axiom + OpenTelemetry

# Estructura del Proyecto:
pds006-frameworks-20252/
├── src/
│   ├── adapter/           # Capa de adaptadores (Infraestructura)
│   │   ├── api/
│   │   │   └── elysia/    # API con Elysia (Puerto de entrada)
│   │   │       ├── controller.elysia.ts
│   │   │       ├── criteria.helper.ts
│   │   │       ├── elysia.api.ts
│   │   │       └── index.ts
│   │   ├── photo/
│   │   │   └── filesystem/ # Almacenamiento de fotos (Puerto de salida)
│   │   └── repository/
│   │       └── inmemory/   # Repositorios en memoria (Puerto de salida)
│   ├── core/              # Núcleo del dominio (Lógica de negocio)
│   │   ├── domain/        # Entidades y Value Objects de dominio
│   │   ├── dto/           # Data Transfer Objects
│   │   ├── repository/    # Interfaces de repositorios (Puertos)
│   │   └── service/       # Servicios de aplicación
│   └── tests/             # Tests del proyecto
├── public/                # Archivos estáticos y fotos
├── .env                   # Variables de entorno
├── .gitignore
├── Dockerfile
├── bun.lock
├── package.json
├── tsconfig.json
└── README.md


# Requisitos Previos:
-Bun >= 1.0.0
-Node.js >= 18.0.0 (opcional, para compatibilidad)
-Cuenta en Axiom para observabilidad


# Instalaciones:
1. Clonar repositorio:
git clone https://github.com/tu-usuario/pds006-frameworks-20252.git
cd pds006-frameworks-20252

2. Instalación dependencias:
bun add @elysiajs/opentelemetry @opentelemetry/sdk-trace-node @opentelemetry/exporter-trace-otlp-proto

bun install

3. Configurar variables de entorno (archivo .env)
# Axiom (Observabilidad)
AXIOM_TOKEN=xaat-tu-token-aqui
AXIOM_DATASET=nombre-de-tu-dataset

4. Obtener credenciales de Axiom
-Crear un nuevo Dataset
-Generar un API Token con permisos de "Ingest"
-Copia el token y dataset al archivo .env



## Inicialización :
bun run dev

Servidor corriendo en: http://localhost:443