FROM alpine

RUN apk add --update --no-cache openssh

COPY entrypoint.sh /entrypoint.sh
COPY update.sh /update.sh

ENTRYPOINT [ "/entrypoint.sh" ]
