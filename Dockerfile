FROM alpine:latest
RUN apk add --no-cache freeradius freeradius-utils freeradius-eap samba-winbind-clients \
&& rm /etc/raddb/sites-enabled/inner-tunnel
CMD [ "/start.sh"]
