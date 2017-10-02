FROM debian:jessie
MAINTAINER Ivo von Putzer Reibegg <info@instant.plus>

ENV DEBIAN_FRONTEND=noninteractive

RUN ln -s -f /bin/true /usr/bin/chfn
RUN apt-get update \
 && apt-get install -y coturn curl procps --no-install-recommends

EXPOSE 3478 3478/udp
ENTRYPOINT /usr/bin/turnserver
