FROM debian:11-slim
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update \
&& apt install -y freeradius \
winbind heimdal-clients
COPY ./conf /conf
RUN chmod +x /conf/entrypoint.sh \
&& rm -rf /var/lib/apt/lists/* \
&& cat <<EOF >> /etc/freeradius/3.0/mods-available/files
#MAC Auth
files authorized_macs {
        key = "%{Calling-Station-Id}"
        usersfile = ${confdir}/authorized_macs
}
EOF
ENV LOGNAME="root" \
SSL_CERT_PATH="/etc/ssl/certs/ssl-cert-snakeoil.pem" \
SSL_KEY_PATH="/etc/ssl/private/ssl-cert-snakeoil.key" \
SSL_CA_PATH="/etc/ssl/certs/ca-certificates.crt" \
DH_PATH="/etc/freeradius/3.0/certs/dh" 
ENTRYPOINT [ "/conf/entrypoint.sh" ]
