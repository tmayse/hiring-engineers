# docker build --rm -t iamtonymayse:eehdd_api .
# 
# .env
# DD_API_KEY=<your_api_key>
# POSTGRES_PASSWORD=<your_postgres_password>
#
FROM python:3.7.0-alpine3.8
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN apk update && apk add --update alpine-sdk postgresql-dev
RUN pip install --upgrade pip
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY gunicorn.conf /etc/gunicorn.d/gunicorn.conf
COPY api.py /usr/src/app/
ENTRYPOINT ["/usr/local/bin/gunicorn", "--config", "/etc/gunicorn.d/gunicorn.conf", "-b", ":8000", "api:app"]
