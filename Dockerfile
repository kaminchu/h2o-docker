FROM alpine:3.9

ENV H2O_VERSION v2.3.0-beta1

RUN apk upgrade --no-cache \
 && apk add --update --no-cache libressl-dev zlib-dev ruby-dev bison\
 && apk add --update --no-cache --virtual build-dependencies build-base curl cmake \
 && curl -SLO https://github.com/h2o/h2o/archive/${H20_VERSION}.tar.gz \
 && tar xzvf ${H2O_VERSION}.tar.gz \
 && cd h2o-${H2O_VERSION#*v} \
 && cmake -DWITH_MRUBY=on . \
 && make \
 && make install \
 && apk del build-dependencies \
 && cd / \
 && rm -rf ${H2O_VERSION} ${H2O_VERSION}.tar.gz /var/cache/apk/*
