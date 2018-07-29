#docker build --rm -t eehdd:api .
FROM eehdd:base
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY logging.conf /logging.conf
COPY gunicorn.conf /gunicorn.conf
COPY api.py /usr/src/app/
ENV DD_API_KEY ${DD_API_KEY}
ENV DD_APP_KEY ${DD_APP_KEY}
ENTRYPOINT ["gunicorn3", "--config", "/gunicorn.conf", "--log-config", "/logging.conf", "-b", ":8080", "api:app"]