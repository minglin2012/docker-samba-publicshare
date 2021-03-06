FROM ubuntu:trusty
MAINTAINER Seti <sebastian.koehlmeier@kyberna.com>

ENV SHARE /srv
EXPOSE 137 138 139 445

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get update && \
	apt-get install --no-install-recommends -y samba && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY smb.conf /etc/samba/smb.conf
RUN useradd -u 1000 -M sambaguest
# Pregenerate password database to prevent warning messages on container startup
RUN /usr/sbin/smbd && sleep 10 && smbcontrol smbd shutdown

ENTRYPOINT ["/usr/sbin/smbd", "-FSD", "-d1", "--option=workgroup=${workgroup:-workgroup}"]
