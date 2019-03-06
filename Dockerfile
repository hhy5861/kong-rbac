FROM kong:0.14.1-alpine
MAINTAINER Mike Huang, hhy5861@gmail.com

ENV KONG_VERSION 0.14.1
ENV KONG_IMAGES_TAG 2.1.1
ENV KONG_DATABASE postgres
ENV KONG_PLUGINS 'bundled, rbac'

RUN apk add --no-cache --virtual .build-deps git \
    && luarocks install --server=http://luarocks.org/manifests/hhy5861 kong-plugin-rbac ${KONG_IMAGES_TAG} \
    && apk del .build-deps 
