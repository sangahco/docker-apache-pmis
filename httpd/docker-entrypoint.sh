#!/usr/bin/env bash
set -e

export APACHE_SSL=${APACHE_SSL:?missing}
export APACHE_SSL_KEY=${APACHE_SSL_KEY:-key.pem}
export APACHE_SSL_CERT=${APACHE_SSL_CERT:-cert.pem}
export SECURED_RESOURCE_ALLOWED_IP=${SECURED_RESOURCE_ALLOWED_IP:-127.0.0.1}

echo "Starting Apache HTTP with the following settings:"
echo "- ssl enabled:     ${APACHE_SSL}"
echo "- ssl key file:    ${APACHE_SSL_KEY}"
echo "- ssl cert file:   ${APACHE_SSL_CERT}"

if [ "$APACHE_SSL" == "1" ]; then
    /usr/sbin/a2enconf ssl.conf
    sed -i 's/*:80/*:443/' /etc/apache2/sites-available/app-host.conf
    sed -i 's/#SSL/SSL/' /etc/apache2/sites-available/app-host.conf
fi

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

if [ $# -eq 0 ]; then
    # if no arguments are supplied start apache
    exec /usr/sbin/apache2ctl -DFOREGROUND
fi

exec "$@"