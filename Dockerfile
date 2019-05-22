FROM alpine:3.8
MAINTAINER wiserain

RUN \
	echo "**** install frolvlad/alpine-python3 ****" && \
	apk add --no-cache python3 && \
	apk add --no-cache --virtual .build-deps gcc musl-dev && \
	python3 -m ensurepip && \
	rm -r /usr/lib/python*/ensurepip && \
	pip3 install --upgrade pip setuptools && \
	if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
	if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
	echo "**** install flexget and addons ****" && \
	apk --no-cache add shadow ca-certificates tzdata py3-cryptography && \
	pip3 install --upgrade \
		transmissionrpc \
		beautifulsoup4==4.6.0 \
		mechanicalsoup \
		requests==2.21.0 \
		certifi==2017.4.17 \
		chardet==3.0.3 \
		idna==2.5 \
		urllib3==1.24.2 \
		cython \
		six==1.10.0 \
		flexget && \
	sed -i 's/^CREATE_MAIL_SPOOL=yes/CREATE_MAIL_SPOOL=no/' /etc/default/useradd && \
	echo "**** cleanup ****" && \
	rm -rf \
		/tmp/* \
		/root/.cache

# copy local files
COPY files/ /

# add default volumes
VOLUME /config /data
WORKDIR /config

# expose port for flexget webui
EXPOSE 3539 3539/tcp

# run init.sh to set uid, gid, permissions and to launch flexget
RUN chmod +x /scripts/init.sh
CMD ["/scripts/init.sh"]
