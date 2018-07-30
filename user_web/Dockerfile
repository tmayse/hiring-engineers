#docker build --rm -t iamtonymayse:eehdd_web .
FROM iamtonymayse:eehdd_base
COPY requirements.txt /usr/src/app/
RUN pip3 install --no-cache-dir -r /usr/src/app/requirements.txt
COPY gunicorn.conf /gunicorn.conf
COPY user_web.py /usr/src/app/
ENTRYPOINT ["gunicorn3", "--config", "/gunicorn.conf", "-b", ":8080", "user_web:app"]
