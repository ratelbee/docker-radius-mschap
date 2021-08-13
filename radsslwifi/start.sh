#!/bin/sh
cd /certs
find ./01.pem ./02.pem ./ca.der ./ca.key ./ca.pem ./client.crt ./client.csr ./client.key ./dh ./index.txt ./index.txt.attr ./index.txt.attr.old ./index.txt.old ./random serial ./serial.old ./server.crt ./server.csr ./server.key ./server.p12 ./server.pem -mmin +1 -delete
./bootstrap
