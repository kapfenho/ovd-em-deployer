#!/bin/sh

# GYBXoDeT1eqp562g
# jcQQxO8OZTVwxQEv

ks=/opt/fmw/services/instances/ovd1/config/OVD/ovd1/keystores/keysnew.jks

keytool -importkeystore \
    -destkeystore $ks \
    -srckeystore /vagrant/local/md5/ovd.vie.agoracon.at.jks \
    -alias "ovd.vie.agoracon.at" \
    -srcstorepass jcQQxO8OZTVwxQEv \
    -deststorepass Montag11
exit 0

keytool -import  \
    -alias pki-root \
    -file /vagrant/local/md5/root.crt \
    -keystore $ks \
    -deststorepass Montag11 \
    -noprompt
