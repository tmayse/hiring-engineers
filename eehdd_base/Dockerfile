#docker build --rm -t eehdd_base .
FROM python:3.7-slim
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN apt-get -y update && apt-get install -y gunicorn3
COPY base_requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/base_requirements.txt