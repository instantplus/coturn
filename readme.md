# docker-coturn
This is a lightweight build of [coturn](https://github.com/coturn/coturn) based on [alpine linux](https://alpinelinux.org/).

### build the docker image
```sh
docker build -t instantplus/coturn:latest .
```

### pull latest image from dockerhub
```sh
docker pull instantplus/coturn:latest
```

### run the built container
```sh
STUN_TURN=3478:3478 # UDP/TCP
STUN_TURN_ALT=3479:3479 # UDP/TCP ALT RFC5780
STUN_TURN_TLS_DTLS=5349:5349 # DLS/DTLS
STUN_TURN_TLS_DTLS_ALT=5350:5350 # DLS/DTLS ALT RFC5780
STUN_TURN_RELAY=49152:65535 # TURN UDP RELAY

docker run instantplus/coturn
  --net host
  --expose ${STUN_TURN}/udp
  --expose ${STUN_TURN}/tcp
  --expose ${STUN_TURN_ALT}/udp
  --expose ${STUN_TURN_ALT}/tcp
  --expose ${STUN_TURN_TLS_DTLS}/udp
  --expose ${STUN_TURN_TLS_DTLS}/tcp
  --expose ${STUN_TURN_TLS_DTLS_ALT}/udp
  --expose ${STUN_TURN_TLS_DTLS_ALT}/tcp
  --expose ${STUN_TURN_RELAY}/udp
  --env PORT=3478
  --env ALT_PORT=3479
  --env TLS_PORT=5349
  --env TLS_ALT_PORT=5350
  --env MIN_PORT=49152
  --env MAX_PORT=65535
  --env JSON_CONFIG="{\"config\":[\"no-auth\"]}"
```

### Notes
- The startup script will auto-discover a public and private IP address, which can be environmentally overridden;
- The startup script will also accept a JSON_CONFIG environment variable containing a JSON formatted string with a config key array of lines to add to the generated coturn configuration file;
- There is presently support compiled in for sqlite3, redis, mysql, and postgresql;
- Mongo support is commented out, as it adds 130M to the image size.
