#!/bin/sh
# Build GO version as specified in Dockerfile

set -x
set -e

# Components versions
export GOLANG_VERSION="1.13.3"
export GOLANG_SRC_URL="https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz"
export GOLANG_SRC_SHA256="4f7123044375d5c404280737fbd2d0b17064b66182a65919ffe20ffe8620e3df"


# Install build tools
apk add --no-cache --no-progress --virtual build-deps-go gcc musl-dev openssl go

export GOROOT_BOOTSTRAP="$(go env GOROOT)"

# Download Go
wget -q "$GOLANG_SRC_URL" -O golang.tar.gz
echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c -
tar -C /usr/local -xzf golang.tar.gz
rm golang.tar.gz

# Build
cd /usr/local/go/src
# see https://golang.org/issue/14851
#patch -p2 -i /app/gogs/build/docker/no-pic.patch
./make.bash

# Clean
rm /app/gogs/build/docker/*.patch
apk del build-deps-go
