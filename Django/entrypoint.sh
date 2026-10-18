#!/bin/sh
set -e

echo "Aplicando migraciones de Django..."
# 1. Simular restaurant porque sus tablas ya existen en el esquema content
python manage.py migrate restaurant --fake || true

# 2. Aplicar las migraciones internas de Django (admin, auth, sessions, etc.)
python manage.py migrate

if [ -n "$DJANGO_SUPERUSER_USERNAME" ]; then
    echo "Verificando/creando superusuario..."
    python manage.py createsuperuser --noinput || true
fi

echo "Iniciando uWSGI..."
exec uwsgi --strict --ini uwsgi.ini