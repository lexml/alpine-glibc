FROM alpine:3.10.0

ENV GLIBC_VERSION 2.29-r0

# Download and install glibc
RUN apk add --update curl && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-i18n.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk" && \
  apk add glibc-bin.apk glibc.apk glibc-i18n.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  echo 'en_US.UTF-8 UTF-8' > /etc/locale.conf && \
  echo 'pt_BR.UTF-8 UTF-8' >> /etc/locale.conf && \
  /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
  echo 'LANG=en_US.UTF-8' > /etc/locale.conf && \
  apk del curl && \
  rm -rf glibc.apk glibc-bin.apk glibc-i18n.apk /var/cache/apk/*
