# consider
# https://github.com/lewispeckover/docker-varnish

FROM alpine:3.8 AS varnish_alpine

EXPOSE 80

RUN apk update && \
    apk upgrade && \
    apk add varnish