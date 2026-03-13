#!/usr/bin/env bash

set -xe

DIR="$(dirname "$(readlink -f "$0")")"

mkdir -p "${DIR}/bin"

git submodule init && git submodule update

pushd "${DIR}/cryostat-agent" || exit
./mvnw -DskipTests clean package
popd || exit
cp "${DIR}"/cryostat-agent/target/cryostat-agent-*-shaded.jar "${DIR}/bin/"

pushd "${DIR}/cryostat-mcp" || exit
./mvnw -DskipTests clean package
popd || exit
cp "${DIR}"/cryostat-mcp/target/cryostat-mcp-*-runner.jar "${DIR}/bin/"

pushd "${DIR}/cryostat" || exit
git submodule init && git submodule update
./mvnw \
    -Dquarkus.container-image.build=false \
    -Dquarkus.package.jar.type=uber-jar \
    -DskipTests \
    clean package
popd || exit
cp "${DIR}"/cryostat/target/cryostat-*-runner.jar "${DIR}/bin/"
