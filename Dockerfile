FROM alpine:latest

WORKDIR /app

COPY app/ .

RUN chmod +x ./*.sh

ENTRYPOINT ["./diagnostic.sh"]