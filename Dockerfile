FROM debian:11-slim
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update \
&& apt install -y freeradius \
samba libnss-winbind heimdal-clients
ADD ./conf /conf
ADD ./default_environment /etc/environment
RUN chmod +x /conf/entrypoint.sh \
&& rm -rf /var/lib/apt/lists/*
ENTRYPOINT [ "/conf/entrypoint.sh" ]
