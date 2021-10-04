FROM debian:11-slim
ADD ./conf /conf
ARG DEBIAN_FRONTEND=noninteractive
EXPOSE 1812/udp
EXPOSE 1813/udp
RUN apt update \
&& apt install -y freeradius \
samba libnss-winbind heimdal-clients \
&& chmod +x /entrypoint.sh \
&& rm -rf /var/lib/apt/lists/*
ENTRYPOINT [ "sh", "/conf/entrypoint.sh"]
