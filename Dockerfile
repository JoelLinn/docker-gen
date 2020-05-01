FROM golang:alpine as builder

ARG SOURCE_REPO=github.com/JoelLinn/docker-gen

RUN apk add --no-cache \
    git \
    make \
    gcc \
    libc-dev

RUN go get ${SOURCE_REPO}
WORKDIR src/${SOURCE_REPO}

RUN make get-deps
RUN make all check-gofmt test
RUN cp docker-gen /

FROM alpine:latest
LABEL maintainer="Joel Linn <jl@conductive.de>"

RUN apk --no-cache add openssl

ENV DOCKER_HOST unix:///tmp/docker.sock

COPY --from=builder /docker-gen /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-gen"]
