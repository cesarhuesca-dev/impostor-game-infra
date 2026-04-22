# Etapa 1: Construcción
FROM node:24.12-alpine AS build

WORKDIR /app

COPY ./frontend/package*.json ./
RUN npm install
COPY ./frontend . 
RUN npm run build -- --configuration=production

# Etapa 2: Servidor de producción
FROM nginx:alpine
# Ajusta la ruta 'dist/nombre-de-tu-app/browser' según tu angular.json
COPY --from=build /app/dist/*/browser /usr/share/nginx/html
# Copiamos una config básica para que Angular maneje las rutas (SPA)
COPY ./nginx/frontend.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
