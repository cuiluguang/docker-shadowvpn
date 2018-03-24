#
# Dockerfile for ShadowVPN
#

FROM alpine
MAINTAINER kev <noreply@easypi.pro>

ENV SERVER_IP 0.0.0.0
ENV SERVER_PORT 1123
ENV PASSWORD my_password
ENV CONCURRENCY 1
ENV MTU 1432
ENV TUN_NAME tun0
ENV USER_TOKEN 7e335d67f1dc2c01,ff593b9e6abeb2a5,e3c7b8db40a96105

RUN apk add -U autoconf \
               automake \
               build-base \
               gawk \
               git \
               iptables \
               libtool \
               linux-headers \
    && cd ./ShadowVPN \
    && ./autogen.sh \
    && ./configure --enable-static --sysconfdir=/etc \
    && make install \
    && cd .. \
    && rm -rf ShadowVPN \
    && apk del autoconf \
               automake \
               build-base \
               gawk \
               git \
               libtool \
               linux-headers \
	&& sed -i 's/{:server_ip}/$SERVER_IP/g' /etc/shadowvpn/server.conf \
	&& sed -i 's/{:server_port}/$SERVER_PORT/g' /etc/shadowvpn/server.conf \
	&& sed -i 's/{:server_password}/$PASSWORD/g' /etc/shadowvpn/server.conf \
	&& sed -i 's/{:server_concurrency}/$CONCURRENCY/g' /etc/shadowvpn/server.conf \
	&& sed -i 's/{:server_mtu}/$MTU/g' /etc/shadowvpn/server.conf \
	&& sed -i 's/{:server_tun}/$TUN_NAME/g' /etc/shadowvpn/server.conf \
	&& sed -i 's/{:server_token}/$USER_TOKEN/g' /etc/shadowvpn/server.conf \
	&& cd ../ \
	&& rm -rf ./ShadowVPN

CMD shadowvpn -c /etc/shadowvpn/server.conf