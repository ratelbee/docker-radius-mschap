Этот образ предназначен для авторизации на Wi-Fi устройствах с помощую учетных записей MS Active Directory, используя EAP MSCHAP.
 
Чеклист для корректной работы и долго аптайма:

- По DNS записи соответствующей переменной FQDN в сети должен быть доступен контроллер домен, или множество контролеров.
- В Active Directory создайте группу содержащую пользователей или группы пользователей, которым разрешена авторизация с помощью сервиса. Название группы передается в переменную ACCESS_GROUP.
- Пароль для авторизации Wi-Fi устройств на радиус сервере задается в переменной RADIUS_SECRET, устройство с любым IP адресом получит доступ к сервису.
- Передайте в переменную TZ временную зону соответсвующую временной зоне контроллера домена.
- В Active Directory создайте пользователя обладающего правами добавления компьютера в домен и способного читать список групп и пользователей. Учетные данные пользователя задаются в переменных KRB_LOGIN и KRB_PASS.
- По умолчанию SSL сертификаты и ключи генерируются при каждом запуске контейнера. Если есть необходимость в постоянных сертификатах, любым доступным способом сгенерируйте сертификаты и примонтируйте их внутрь при запуске контейнера, передав в переменные SSL_CERT_PATH, SSL_KEY_PATH, SSL_CA_PATH, DH_PATH путь внутри контейнера.

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
```
