#!/bin/bash

REALM="OTUS.LAN"
DOMAIN="otus.lan"
SERVER_FQDN="lab.otus.lan"
CLIENT_FQDN="comp.otus.lan"

export DEBIAN_FRONTEND=noninteractive
apt update
apt install -y nfs-kernel-server krb5-kdc krb5-admin-server acl

cat << EOF >> /etc/hosts
192.168.122.212 lab.otus.lan lab
192.168.122.57 comp.otus.lan comp
EOF

cat << EOF > /etc/krb5.conf
[libdefaults]
    default_realm = $REALM
    dns_lookup_realm = false
    dns_lookup_kdc = false
    forwardable = true

[realms]
    $REALM = {
        kdc = $SERVER_FQDN
        admin_server = $SERVER_FQDN
        default_domain = $DOMAIN
        database_name = /var/lib/krb5kdc/principal
        admin_keytab = /etc/krb5kdc/kadm5.keytab
        acl_file = /etc/krb5kdc/kadm5.acl
        key_stash_file = /etc/krb5kdc/stash
    }

[domain_realm]
    .$DOMAIN = $REALM
    $DOMAIN = $REALM
EOF

rm -rf /var/lib/krb5kdc/*
kdb5_util create -s -P "masterpass" # Мастер-пароль базы

kadmin.local -q "addprinc -pw 123 dev"
kadmin.local -q "addprinc -pw 123 test"

kadmin.local -q "addprinc -randkey nfs/$SERVER_FQDN"
kadmin.local -q "addprinc -randkey nfs/$CLIENT_FQDN"

kadmin.local -q "ktadd nfs/$SERVER_FQDN"

rm -f /tmp/krb5.keytab
kadmin.local -q "ktadd -k /tmp/krb5.keytab nfs/$CLIENT_FQDN"
chmod 644 /tmp/krb5.keytab

useradd -M -s /usr/sbin/nologin dev || true
useradd -M -s /usr/sbin/nologin test || true

mkdir -p /mnt/data/{prod,test}
chown -R root:root /mnt/data
chmod -R 755 /mnt/data

setfacl -m u:dev:rwx /mnt/data/prod
setfacl -d -m u:dev:rwx /mnt/data/prod
setfacl -m u:test:rx /mnt/data/prod
setfacl -d -m u:test:rx /mnt/data/prod

setfacl -m u:dev:rwx /mnt/data/test
setfacl -d -m u:dev:rwx /mnt/data/test
setfacl -m u:test:rwx /mnt/data/test
setfacl -d -m u:test:rwx /mnt/data/test

#setfacl -m u:user:rx /mnt/data/prod
#setfacl -m u:user:rx /mnt/data/test/

cat << EOF > /etc/exports
/mnt/data  $CLIENT_FQDN(rw,sec=krb5p,no_subtree_check)
EOF

cat << EOF > /etc/idmapd.conf
[General]
Verbosity = 0
Domain = $DOMAIN
[Mapping]
Nobody-User = nobody
Nobody-Group = nogroup
EOF

systemctl restart krb5-kdc krb5-admin-server nfs-kernel-server

echo "СКОПИРУЙТЕ /tmp/krb5.keytab НА КЛИЕНТА!"
