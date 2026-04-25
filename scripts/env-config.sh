#!/bin/sh

# 1. Definimos qué variables queremos inyectar en el HTML
export VARS_TO_SUBSTITUTE='$HOST_FRONT' # (Esto evita que envsubst toque cosas que no debe)

# 2. Inyectamos en el index.html
# Leemos el original, reemplazamos y lo guardamos sobre sí mismo
envsubst "$VARS_TO_SUBSTITUTE" < /usr/share/nginx/html/index.html > /usr/share/nginx/html/index.tmp && mv /usr/share/nginx/html/index.tmp /usr/share/nginx/html/index.html

# 3. Inyectamos en el env.js (lo que ya hacíamos para Angular)
envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js

echo "✔ Index.html y env.js actualizados correctamente."

# 4. Iniciar Nginx
exec "$@"