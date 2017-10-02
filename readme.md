# docker-coturn
This is a lightweight build of [coturn](https://github.com/coturn/coturn) based on [alpine linux](https://alpinelinux.org/).

### build the docker image
```sh
docker build -t instantplus/coturn:latest ./
```

### pull latest image from dockerhub
```sh
docker pull instantplus/coturn:latest
```

### run the built container
```sh
docker run -it coturn \
  --verbose \
  --fingerprint \
  --lt-cred-mech \
  --user=username:password \
  --realm=instant.plus \
  --log-file stdouts
```

### Notes
- The startup script will auto-discover a public and private IP address, which can be environmentally overridden;
- The startup script will also accept a JSON_CONFIG environment variable containing a JSON formatted string with a config key array of lines to add to the generated coturn configuration file;
- There is presently support compiled in for sqlite3, redis, mysql, and postgresql;
- Mongo support is commented out, as it adds 130M to the image size.
