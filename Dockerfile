FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update \
  && apt-get install -y vim  vsftpd \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty

ADD start.sh /a/start.sh
RUN chmod 777 /a/start.sh
CMD ["/a/start.sh"]