build:
	docker run build -t coturn .
start:
	docker run -it coturn --verbose --fingerprint --lt-cred-mech --user=username:password --realm=instant.plus --log-file stdout
