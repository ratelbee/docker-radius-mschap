FROM archdock.alyans-auto.ru:5000/alpine
RUN apk add freeradius freeradius-utils freeradius-eap samba-winbind-clients && rm /etc/raddb/sites-enabled/inner-tunnel
COPY ./3.0 /etc/raddb
CMD [ "radiusd","-f"]
