FROM eeacms/varnish:latest

EXPOSE 80
COPY conf.d /conf.d
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT /start.sh
