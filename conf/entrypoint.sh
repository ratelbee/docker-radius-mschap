#!/bin/sh

cat <<EOF > /etc/krb5.conf
[libdefaults]
        default_realm 	= 	${FQDN}
        default_keytab_name = /etc/krb5.keytab
	clockskew 	= 	300
	ticket_lifetime	=	1d
        forwardable     =       true
        proxiable       =       true
        dns_lookup_realm =      true
        dns_lookup_kdc  =       true

[realms]
	${FQDN} = {
		kdc     	= ${FQDN}
                admin_server    = ${FQDN}
		default_domain  = ${FQDN}
	}

[appdefaults]
	pam = {
	ticket_lifetime 	= 1d
	renew_lifetime 		= 1d
	forwardable 		= true
	proxiable 		= false
	retain_after_close 	= false
	minimum_uid 		= 0
	debug 			= false
	}

[logging]
	default 		= FILE:/var/log/krb5libs.log
	kdc 			= FILE:/var/log/kdc.log
        admin_server            = FILE:/var/log/kadmind.log
EOF

cat <<EOF > /etc/samba/smb.conf
[global]
   netbios name = ${HOSTNAME}
   workgroup    = ${FQDN_SHORT}
   realm        = ${FQDN}
   security     = ADS


   # Load the acl_xattr module for Windows ACL support
   vfs objects = shadow_copy2 acl_xattr

   # Use an external keytab that can be used for other services (e.g. apache)
   kerberos method = dedicated keytab
   dedicated keytab file = /etc/krb5.keytab

   idmap config *:backend = tdb
   idmap config *:range   = 1000000-1999999

   # Make sure we have reproducible user IDs
   idmap config LOCALLAN:backend = rid
   idmap config LOCALLAN:range   = 10000-999999

   winbind nss info = rfc2307

   # should "getent passwd" and "getent group" list *all* AD users/groups?
   winbind enum users  = yes
   winbind enum groups = yes

   # Default shell that users get (/bin/true = no login)
   template shell = /bin/true
EOF

cat <<EOF > /etc/nsswitch.conf
passwd:         files systemd winbind
group:          files systemd winbind
shadow:         files
gshadow:        files

hosts:          files dns
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:       nis
sudoers:        files
EOF

echo $KRB_PASS | kinit --password-file=STDIN $KRB_LOGIN
net ads -k join
net ads -k keytab create
kdestroy
service smbd restart && service nmbd restart && service winbind restart

cp -r /conf/raddb/* /etc/freeradius/3.0/
rm etc/freeradius/3.0/sites-enabled/inner-tunnel

freeradius -X