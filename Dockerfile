FROM alpine

COPY entrypoint.sh /entrypoint.sh
COPY update.sh /update.sh

ENTRYPOINT [ "/entrypoint.sh" ]
