# docker build --rm -t iamtonymayse:eehdd_web .
# 
# .env
# DD_API_KEY=<your_api_key>
# POSTGRES_PASSWORD=<your_postgres_password>
#
FROM python:3.7.0-alpine3.8
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN apk update && apk add --update alpine-sdk postgresql-dev
COPY requirements.txt /usr/src/app/
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY gunicorn.conf /etc/gunicorn.d/gunicorn.conf
COPY user_web.py /usr/src/app/
ENTRYPOINT ["gunicorn", "--config", "/etc/gunicorn.d/gunicorn.conf", "-b", ":8080", "user_web:app"]
