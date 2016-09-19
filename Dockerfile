FROM debian
MAINTAINER Jacek Kowalski <Jacek@jacekk.info>, Jonathan Karras <jkarras@karras.net>

ENV UNIFI_VERSION 5.2.7-8f01bc80

RUN apt-get update \
	&& apt-get -y dist-upgrade \
	&& apt-get -y install wget jsvc openjdk-7-jre-headless mongodb-server binutils \
	&& apt-get -y clean

RUN cd /tmp \
	&& wget "https://www.ubnt.com/downloads/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb" \
	&& dpkg -i unifi_sysvinit_all.deb \
	&& rm -rf unifi_sysvinit_all.deb /var/lib/unifi/*

EXPOSE 8080 8081 8443 8843 8880

VOLUME /usr/lib/unifi/data

WORKDIR /var/lib/unifi
CMD ["/usr/bin/java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
