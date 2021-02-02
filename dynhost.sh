#!/bin/sh

if [ $DYNHOST_DOMAIN_NAME_FILE ]; then
    DYNHOST_DOMAIN_NAME=$(cat $DYNHOST_DOMAIN_NAME_FILE)
fi
if [ $DYNHOST_LOGIN_FILE ]; then
    DYNHOST_LOGIN=$(cat $DYNHOST_LOGIN_FILE)
fi
if [ $DYNHOST_PASSWORD_FILE ]; then
    DYNHOST_PASSWORD=$(cat $DYNHOST_PASSWORD_FILE)
fi

echo "Checking IP" >> dynhost.log

IP=$(dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | tr -d \")
CURRENT_IP=$(dig +short $DYNHOST_DOMAIN_NAME)

if [ "$IP" ]; then
    if [ "$CURRENT_IP" != "$IP" ]; then
        echo "Updating $DYNHOST_DOMAIN_NAME from $CURRENT_IP to $IP" >> dynhost.log
        curl --user "${DYNHOST_LOGIN}:${DYNHOST_PASSWORD}" "http://www.ovh.com/nic/update?system=dyndns&hostname=${DYNHOST_DOMAIN_NAME}&myip=${IP}" >> dynhost.log 2>&1
    else
        echo "No update required" >> dynhost.log
    fi
else
    echo "IP not found" >> dynhost.log
fi
