# docker-freeswitch

Dockerfile for running [FreeSWITCH](https://freeswitch.org) in a Docker container.

* Base image: `debian:jessie-slim
* Exposed ports: None
* Volumes: None


### Build
```
docker build -t freeswitch .
```

### Usage
You should generally run the container with host networking. Something like:
```
docker run -d --net host -v /var/log/freeswitch:/var/log/freeswitch --name freeswitch freeswitch
```

If you want to use FreeSWITCH's CLI, you can use Docker's `exec` command to connect to the running container:
```
docker exec -it freeswitch fs_cli
```

### Networking
It is not recommended that you use Docker's bridge networking mode for FreeSWITCH as some of the protocols (namely, SIP) make use of a very large number of ports and it is not feasible to forward all of these ports to the host. Instead, consider using Docker's host networking mode or a network type that gives the container its own IP address.

We disable IPv6 networking for Sofia and the Event Socket as there seem to be problems in some recent versions of FreeSWITCH with platforms that don't support IPv6 (e.g. inside a Docker container with bridge networking with the default Docker daemon settings).
