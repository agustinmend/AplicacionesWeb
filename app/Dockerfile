FROM python:3.12.7
WORKDIR /app
COPY requirements.txt .
RUN pip install --default-timeout=300 --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["gunicorn", "-c", "gunicorn.conf.py", "wsgi:app"]