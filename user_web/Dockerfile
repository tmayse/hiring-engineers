#docker build --rm -t eehdd:user_web .
FROM eehdd:base
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY logging.conf /logging.conf
COPY gunicorn.conf /gunicorn.conf
COPY user_web.py /usr/src/app/
ENTRYPOINT ["gunicorn3", "--config", "/gunicorn.conf", "--log-config", "/logging.conf", "-b", ":8080", "user_web:app"]