#!/bin/bash

. version

VERSION=`./tag-name.sh`

function getExtraParameters {
  if [ ! -z "$http_proxy" ]; then
    PROXY_BASE=$(echo $http_proxy | cut -d/ -f3)
    PROXY_HOST=$(ip addr list docker0 | grep "inet " | cut -d' ' -f6 | cut -d/ -f1)
    PROXY_PORT=$(echo $PROXY_BASE | cut -d: -f2) 
    PROXY="http://"$(ip addr list docker0 |grep "inet " |cut -d' ' -f6|cut -d/ -f1)":3128"
    echo "--build-arg http_proxy=$PROXY --build-arg https_proxy=$PROXY --build-arg http_host=$PROXY_HOST \
          --build-arg http_port=$PROXY_PORT --build-arg HTTP_PROXY=$PROXY"
  else
    echo ""
  fi
}

EXTRA_PARAMS=$(getExtraParameters)

echo docker build ${EXTRA_PARAMS} --build-arg "ALPINE_VERSION=$ALPINE_VERSION" \
    --build-arg "GLIBC_VERSION=$GLIBC_VERSION" \
    . -t lexmlbr/alpine-glibc:${VERSION}

docker build ${EXTRA_PARAMS} --build-arg "ALPINE_VERSION=$ALPINE_VERSION" \
    --build-arg "GLIBC_VERSION=$GLIBC_VERSION" \
    . -t lexmlbr/alpine-glibc:${VERSION}
