FROM python:3.12.7
WORKDIR /proyecto
COPY requirements.txt .
RUN pip install --default-timeout=300 --no-cache-dir -r requirements.txt
COPY . ./app
EXPOSE 5000
CMD ["gunicorn", "-c", "app/gunicorn.conf.py", "app.wsgi:app"]