FROM iamtonymayse:eehdd_cache_base

EXPOSE 80

COPY conf.d /conf.d
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT /start.sh
