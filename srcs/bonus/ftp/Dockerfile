FROM alpine:3.20.6

RUN apk add --no-cache tini vsftpd

COPY ./entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY ./conf/vsftpd.conf /etc/vsftpd.conf

ENTRYPOINT ["/sbin/tini","--","docker-entrypoint.sh"]
CMD ["vsftpd",  "/etc/vsftpd.conf"]
