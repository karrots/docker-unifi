FROM debian:jessie
MAINTAINER Jacek Kowalski <Jacek@jacekk.info>

ENV UNIFI_VERSION 5.4.16

RUN echo 'deb http://httpredir.debian.org/debian jessie-backports main' > \
                /etc/apt/sources.list.d/jessie-backports.list \
	&& apt-get update \
	&& apt-get -y dist-upgrade \
	&& apt-get -y -t jessie-backports install \
		wget jsvc openjdk-8-jre-headless mongodb-server binutils sudo \
	&& apt-get -y clean

RUN cd /tmp \
	&& wget "https://www.ubnt.com/downloads/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb" \
	&& dpkg -i unifi_sysvinit_all.deb \
	&& rm -rf unifi_sysvinit_all.deb /var/lib/unifi/*

RUN groupadd -r -g 500 unifi \
	&& useradd -r -d /usr/lib/unifi -u 500 -g 500 unifi \
	&& chown -Rf unifi:unifi /usr/lib/unifi

EXPOSE 8080 8081 8443 8843 8880

VOLUME /usr/lib/unifi/data

WORKDIR /var/lib/unifi
COPY run.sh /run.sh
CMD /run.sh
