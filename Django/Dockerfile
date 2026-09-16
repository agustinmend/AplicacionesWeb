FROM python:3.10

WORKDIR /opt/app
ENV DJANGO_SETTINGS_MODULE='config.settings'

RUN groupadd -r web && useradd -r -g web web

COPY requirements.txt requirements.txt
COPY uwsgi.ini uwsgi.ini

RUN pip install --upgrade pip \
    && pip install -r requirements.txt

COPY . .
RUN python manage.py collectstatic --noinput
EXPOSE 8000

USER web

ENTRYPOINT ["uwsgi", "--strict", "--ini", "uwsgi.ini"]