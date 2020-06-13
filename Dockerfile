FROM alpine

RUN apk add --update --no-cache openssh rsync shadow

COPY entrypoint.sh /entrypoint.sh
COPY deploy.sh /deploy.sh

ENTRYPOINT [ "/bin/sh", "-c", "usermod -d $HOME $USER && /entrypoint.sh" ]
