FROM golang:1.22-bookworm as builder
COPY . /go/src/github.com/lebokus/docker-volume-bindfs
WORKDIR /go/src/github.com/lebokus/docker-volume-bindfs
RUN set -ex && \
    go install --ldflags '-extldflags "-static"'
CMD ["/go/bin/docker-volume-bindfs"]

FROM debian:bookworm-slim
RUN apt-get update && apt-get install bindfs -y
RUN mkdir -p /run/docker/plugins /mnt/state /mnt/volumes /mnt/host/
COPY --from=builder /go/bin/docker-volume-bindfs .
CMD ["docker-volume-bindfs"]
