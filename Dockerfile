FROM alpine:latest

MAINTAINER palw3ey <palw3ey@gmail.com>
LABEL name="ye3ftp" version="1.0.1" author="palw3ey" maintainer="palw3ey" email="palw3ey@gmail.com" website="https://github.com/palw3ey/ye3ftp" license="MIT" create="20231204" update="20240224" description="A docker FTP server based on vsftpd and Alpine. Below 15 Mb. GNS3 ready." usage="docker run -dt palw3ey/ye3ftp" tip="The folder /data is persistent, default login: tux/1234" 
LABEL org.opencontainers.image.source=https://github.com/palw3ey/ye3ftp

ENV Y_LANGUAGE=fr_FR \
	Y_DEBUG=no \
	Y_IP=0.0.0.0 \
	Y_PORT=21 \
	Y_USER=tux \
	Y_PASSWORD=1234 \
	Y_UID=1000 \
	Y_GID=1000 \
	Y_PERMISSION=0775 \
	Y_INDIVIDUAL_FOLDER=yes \
	Y_PASV=yes \
	Y_PASV_ADDRESS= \
	Y_PASV_MIN=0 \
	Y_PASV_MAX=0 \
	Y_ANONYMOUS=no \
	Y_ANONYMOUS_WRITE=no \
	Y_SSL=no \
	Y_SSL_FORCE=no \
	Y_SSL_IMPLICIT=no

ADD entrypoint.sh mgmt.sh /
ADD i18n/ /i18n/
ADD bypass_docker_env.sh.dis /etc/profile.d

RUN apk add --update --no-cache vsftpd lftp ; \
	chmod +x /entrypoint.sh ; \
	chmod +x /mgmt.sh ; \
	ln -sfn /mgmt.sh /usr/sbin/mgmt

EXPOSE $Y_PORT/tcp

VOLUME /data

ENTRYPOINT sh --login -c "/entrypoint.sh"
