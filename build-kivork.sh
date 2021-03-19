#!/bin/bash
set -x

TMP_DIR=$(mktemp -d -t ci-XXXXXXXXXX)

BUILD_TAG="3.3.4"

echo "Building tag: $BUILD_TAG"

nvm use 12.18
rm -rf node_modules
npm ci

meteor build --directory $TMP_DIR
cp .docker/Dockerfile $TMP_DIR
cd $TMP_DIR
sudo docker build -t docker-registry.travelinsides.com/rocketchat:$BUILD_TAG -f Dockerfile .


sudo docker login https://docker-registry.travelinsides.com/
sudo docker push docker-registry.travelinsides.com/rocketchat:$BUILD_TAG
echo "Done docker-registry.travelinsides.com/rocketchat:$BUILD_TAG"

