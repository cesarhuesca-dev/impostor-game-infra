# --- Etapa 1: Build ---
FROM node:24.12-alpine AS build

WORKDIR /app

# Al estar en /infra, entramos a la carpeta del submodulo frontend
COPY ./frontend/package*.json ./
RUN npm install

# Copiamos todo el contenido del submodulo frontend al WORKDIR (/app)
COPY ./frontend . 

# Compilamos Angular
RUN npm run build -- --configuration=production

# --- Etapa 2: Producción ---
FROM nginx:alpine

# Instalamos gettext para tener 'envsubst'
RUN apk add --no-cache gettext

# 1. Copiamos los archivos compilados (ajusta el asterisco si conoces el nombre de la app)
COPY --from=build /app/dist/*/browser /usr/share/nginx/html

# 2. Copiamos el template de variables desde el submódulo
COPY ./frontend/src/assets/js/env.template.js /usr/share/nginx/html/assets/env.template.js

# 3. Copiamos el script de arranque desde la carpeta de infra
COPY ./scripts/env-config.sh /docker-entrypoint.d/40-env-config.sh
RUN chmod +x /docker-entrypoint.d/40-env-config.sh

# 4. Copiamos la config de Nginx
COPY ./nginx/frontend.conf /etc/nginx/conf.d/default.conf

EXPOSE 80