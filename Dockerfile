FROM alpine

RUN apk add --update --no-cache openssh

COPY entrypoint.sh /entrypoint.sh
COPY deploy.sh /deploy.sh

ENTRYPOINT [ "/entrypoint.sh" ]
