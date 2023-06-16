FROM golang:1.20.4 as build

COPY . /src/loki
WORKDIR /src/loki
RUN make clean && make -j4 BUILD_IN_CONTAINER=false loki

FROM alpine:3.16.5

RUN apk add --no-cache ca-certificates libcap

COPY --from=build /src/loki/cmd/loki/loki /usr/bin/loki

RUN addgroup -g 10001 -S loki && \
    adduser -u 10001 -S loki -G loki
RUN mkdir -p /loki/rules && \
    mkdir -p /loki/rules-temp && \
    mkdir -p /etc/loki && \
    chown -R loki:loki /loki

COPY ./tests/loki/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

USER 10001
EXPOSE 3100

ENTRYPOINT [ "/bin/sh", "./entrypoint.sh" ]
