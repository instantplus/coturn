FROM debian:jessie
MAINTAINER Ivo von Putzer Reibegg <ivo@instant.plus>

ENV DEBIAN_FRONTEND noninteractive
RUN ln -s -f /bin/true /usr/bin/chfn
RUN apt-get update \
 && apt-get install -y --no-install-recommends coturn curl procps

ADD turnserver.sh /turnserver.sh
EXPOSE 3478 3478/udp

CMD ["/bin/sh", "/turnserver.sh"]
