FROM archdock.alyans-auto.ru:5000/alpine
RUN apk add openssl
COPY ./start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
