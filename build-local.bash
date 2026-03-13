#!/usr/bin/env bash

DIR="$(dirname "$(readlink -f "$0")")"

mkdir -p "${DIR}/bin"

pushd "${DIR}/cryostat" || exit
./mvnw \
    -Dquarkus.container-image.build=false \
    -Dquarkus.package.jar.type=uber-jar \
    -DskipTests \
    clean package
popd || exit
cp "${DIR}/cryostat/target/cryostat-*-runner.jar" "${DIR}/bin/"

pushd "${DIR}/cryostat-agent" || exit
./mvnw clean package
popd || exit
cp "${DIR}/cryostat-agent/target/cryostat-agent-*-shaded.jar" "${DIR}/bin/"
