This image  is Intended for authorization on Wi-Fi devices using MS Active Directory accounts using EAP MSCHAP.
 
Checklist for correct operation and Long Uptime:

- According to the DNS record of the corresponding FQDN variable, a domain controller, or many controllers, must be available on the network.
- In Active Directory, create a group containing users or groups of users who are allowed to authorize using the service. The group name is passed to the ACCESS_GROUP variable.
- The password for authorizing Wi-Fi devices on the radius server is set in the RADIUS_SECRET variable, a device with any IP address will gain access to the service.
- Pass in the TZ variable the time zone corresponding to the time zone of the domain controller.
- In Active Directory, create a user with the rights to add a computer to the domain and able to read the list of groups and users. User credentials are specified in the KRB_LOGIN and KRB_PASS variables.
- By default, SSL certificates and keys are generated each time the container is started. If there is a need for permanent certificates, generate certificates in any available way and mount them inside when starting the container, passing the path inside the container to the SSL_CERT_PATH, SSL_KEY_PATH, SSL_CA_PATH, DH_PATH variables. 

Example of Docker run

```
docker run -itd \
   -p 1812:1812/udp \
   -p 1813:1813/udp \
   -e HOSTNAME=PC \
   -e FQDN=EXAMPLE.COM \
   -e FQDN_SHORT=EXAMPLE \
   -e ACCESS_GROUP="radiuswifi" \
   -e RADIUS_SECRET="SECRET" \
   -e TZ="Europe/Moscow" \
   -e KRB_LOGIN="AD_USER" \
   -e KRB_PASS="AD_PASSWORD" \
   -e MODE=PEAP-AND-MAC \
   -v $(pwd)/authorized_macs:/etc/freeradius/3.0/authorized_macs \
   ratelbee/docker-radius-mschap
```

Example of Docker Compose File

```
version: '3.8'
services:
   radius:
      image: ratelbee/docker-radius-mschap
      ports:
         - 1812:1812/udp
         - 1813:1813/udp
      env_file:
         - ./var.env
      volume: 
         - ./authorized_macs:/etc/freeradius/3.0/authorized_macs
      restart: always
```
Required Variables

```
HOSTNAME=PC
FQDN=EXAMPLE.COM
FQDN_SHORT=EXAMPLE
ACCESS_GROUP=radiuswifi
RADIUS_SECRET=SECRET
TZ=Europe/Moscow
KRB_LOGIN=AD_USER
KRB_PASS=AD_PASSWORD
```
Other Variables

```
SSL_CERT_PATH="/etc/ssl/certs/ssl-cert-snakeoil.pem"
SSL_KEY_PATH="/etc/ssl/private/ssl-cert-snakeoil.key"
SSL_CA_PATH="/etc/ssl/certs/ca-certificates.crt"
DH_PATH="/etc/freeradius/3.0/certs/dh"
MODE=PEAP-AND-MAC
MAC_LIST_PATH=/etc/freeradius/3.0/authorized_macs
```
