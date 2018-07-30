#docker build --rm -t iamtonymayse:eehdd_api .
FROM python:3.7-slim
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN apt-get -y update && apt-get install -y gunicorn3 python3-dev build-essential
COPY requirements.txt /usr/src/app/
RUN pip3 install --no-cache-dir -r /usr/src/app/requirements.txt
COPY gunicorn.conf /gunicorn.conf
COPY api.py /usr/src/app/
CMD /bin/sh
#ENTRYPOINT ["gunicorn3", "--config", "/gunicorn.conf", "-b", ":8080", "api:app"]
