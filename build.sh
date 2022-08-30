#!/bin/bash
set -ex

which docker
if [[ -z $(which jq) ]]
then
# || true in case of broken repos
sudo apt-get update -qq || true
sudo apt-get install -y jq
fi

docker build --no-cache -t "$1" .
docker push "$1"

docker pull aquasec/trivy:latest

touch result

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:latest -q image --no-progress --format json "$1" > result

# if in target then there are vulnerabilities
if [ "$(jq 'any(.Results[].Target; contains("container-diff-linux-amd64"))' "result" )" = "true" ]
then
rm result
exit 1
fi
