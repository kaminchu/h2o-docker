FROM alpine:3.9 as builder

ENV H2O_VERSION v2.3.0-beta1

WORKDIR /work

RUN apk upgrade --no-cache \
 && apk add --update --no-cache openssl-dev zlib-dev ruby-dev bison \
 && apk add --update --no-cache --virtual build-dependencies build-base curl cmake \
 && curl -SLO https://github.com/h2o/h2o/archive/${H2O_VERSION}.tar.gz \
 && tar xzvf ${H2O_VERSION}.tar.gz \
 && cd h2o-${H2O_VERSION#*v} \
 && cmake -DWITH_BUNDLED_SSL=on -DWITH_MRUBY=on . \
 && make -j 4 \
 && make install \
 && apk del build-dependencies \
 && cd / \
 && rm -rf ${H2O_VERSION} ${H2O_VERSION}.tar.gz /var/cache/apk/*

FROM alpine:3.9

COPY --from=builder /usr/local/bin/h2o /usr/local/bin
COPY --from=builder /usr/local/share/h2o /usr/local/share/h2o
COPY --from=builder /usr/local/lib64/libh2o-evloop.a /usr/local/lib64/libh2o-evloop.a

EXPOSE 8080 8443
CMD ["h2o"]
