#!/bin/bash

REALM="OTUS.LAN"
DOMAIN="otus.lan"
SERVER_FQDN="lab.otus.lan"

export DEBIAN_FRONTEND=noninteractive
apt update
apt install -y nfs-common krb5-user keyutils

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
    }

[domain_realm]
    .$DOMAIN = $REALM
    $DOMAIN = $REALM
EOF

cat << EOF > /etc/idmapd.conf
[General]
Verbosity = 0
Domain = $DOMAIN
[Mapping]
Nobody-User = nobody
Nobody-Group = nogroup
EOF

mv /tmp/krb5.keytab /etc/krb5.keytab
chmod 600 /etc/krb5.keytab

sed -i 's/^NEED_GSSD=.*/NEED_GSSD="yes"/' /etc/default/nfs-common 2>/dev/null || true
sed -i 's/^NEED_IDMAPD=.*/NEED_IDMAPD="yes"/' /etc/default/nfs-common 2>/dev/null || true
systemctl restart rpc-gssd nfs-idmapd

mkdir -p /mnt/nfs_share

mount -t nfs4 -o sec=krb5p $SERVER_FQDN:/mnt/data /mnt/nfs_share


