#!/bin/sh
set -e
echo "Iniciando uWSGI..."
exec uwsgi --strict --ini uwsgi.ini