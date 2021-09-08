FROM alpine:latest
COPY ./start.sh /start.sh
RUN apk add --no-cache freeradius freeradius-utils freeradius-eap samba-winbind-clients \
&& rm /etc/raddb/sites-enabled/inner-tunnel \
&& chmod +x start.sh
CMD [ "/start.sh"]
