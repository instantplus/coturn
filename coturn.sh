#!/bin/bash

# Discover public and private IP for this instance
PUBLIC_IPV4="$(curl -qs http://169.254.169.254/2014-11-05/meta-data/public-ipv4)"
[ -n "$PUBLIC_IPV4" ] || PUBLIC_IPV4="$(curl -qs ipinfo.io/ip)"
PRIVATE_IPV4="$(curl -qs http://169.254.169.254/2014-11-05/meta-data/local-ipv4)"
[ -n "$PRIVATE_IPV4" ] || PRIVATE_IPV4="$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)"

# Yes, this does work. See: https://github.com/ianblenke/aws-6to4-docker-ipv6
#IPV6="$(ip -6 addr show eth0 scope global | grep inet6 | awk '{print $2}')"

PORT=${PORT:-3478}
ALT_PORT=${PORT:-3479}

TLS_PORT=${TLS:-5349}
TLS_ALT_PORT=${PORT:-5350}

MIN_PORT=${MIN_PORT:-49152}
MAX_PORT=${MAX_PORT:-65535}

TURNSERVER_CONFIG=/app/etc/turnserver.conf

cat <<EOF > ${TURNSERVER_CONFIG}-template
# https://github.com/coturn/coturn/blob/master/examples/etc/turnserver.conf
listening-port=${PORT}
min-port=${MIN_PORT}
max-port=${MAX_PORT}
EOF

if [ "${PUBLIC_IPV4}" != "${PRIVATE_IPV4}" ]; then
  echo "external-ip=${PUBLIC_IPV4}/${PRIVATE_IPV4}" >> ${TURNSERVER_CONFIG}-template
else
  echo "external-ip=${PUBLIC_IPV4}" >> ${TURNSERVER_CONFIG}-template
fi

if [ -n "${JSON_CONFIG}" ]; then
  echo "${JSON_CONFIG}" | jq -r '.config[]' >> ${TURNSERVER_CONFIG}-template
fi

if [ -n "$SSL_CERTIFICATE" ]; then
  echo "$SSL_CA_CHAIN" > /app/etc/turn_server_cert.pem
  echo "$SSL_CERTIFICATE" >> /app/etc/turn_server_cert.pem
  echo "$SSL_PRIVATE_KEY" > /app/etc/turn_server_pkey.pem

  cat <<EOT >> ${TURNSERVER_CONFIG}-template
tls-listening-port=${TLS_PORT}
alt-tls-listening-port=${TLS_ALT_PORT}
cert=/app/etc/turn_server_cert.pem
pkey=/app/etc/turn_server_pkey.pem
EOT

fi

# Allow for ${VARIABLE} substitution using envsubst from gettext
envsubst < ${TURNSERVER_CONFIG}-template > ${TURNSERVER_CONFIG}

exec /app/bin/turnserver
