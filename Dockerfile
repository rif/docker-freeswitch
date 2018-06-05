FROM debian:jessie-slim
LABEL maintainer "rif <radu@fericean.ro>"

# Add FreeSWITCH 1.6 repo
RUN echo 'deb http://files.freeswitch.org/repo/deb/freeswitch-1.6 jessie main' \
        > /etc/apt/sources.list.d/freeswitch.list \
    && apt-key adv --keyserver pool.sks-keyservers.net --recv-key 20B06EE621AB150D40F6079FD76EDC7725E010CF

# Install FreeSWITCH and necessary modules
RUN apt-get update; \
    apt-get install -y freeswitch-meta-all; \
    rm -rf /var/lib/apt/lists/*

# copy custom configs
COPY config/ /etc/freeswitch/

# Disable the example gateway and the IPv6 SIP profiles
RUN set -ex; \
    cd /etc/freeswitch; \
    rm -rf directory/default/example.com.xml; \
    rm -rf sip_profiles/internal*; \
    rm -rf sip_profiles/*ipv6*

# Don't expose any ports - use host networking

# Export logs and cdrs
VOLUME /var/log/freeswitch/

# Set up the entrypoint
COPY entrypoint.sh /usr/local/bin/freeswitch-entrypoint.sh
ENTRYPOINT ["freeswitch-entrypoint.sh"]
CMD ["-c", "-u", "freeswitch", "-g", "freeswitch"]
