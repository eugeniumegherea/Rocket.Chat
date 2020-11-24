#!/bin/bash
set -x
# Take latest stable branch

TMP_DIR=$(mktemp -d -t ci-XXXXXXXXXX)

get_latest_release() {
  git fetch --tags
  git tag | tail -1
}

LATEST_TAG=$(get_latest_release)
# BRANCH="em_resumetoken_goto"
COMMIT_ID="1e91b6d057c73d2aa5e892be71d27716f0a29035"

echo "Last tag: $LATEST_TAG"

git checkout tags/$LATEST_TAG
git cherry-pick $COMMIT_ID


npm i
meteor build --directory $TMP_DIR
cp .docker/Dockerfile $TMP_DIR
cd $TMP_DIR
sudo docker build -t docker-registry.travelinsides.com/rocketchat:$LATEST_TAG -f Dockerfile .


sudo docker login https://docker-registry.travelinsides.com/
sudo docker push docker-registry.travelinsides.com/rocketchat:$LATEST_TAG
echo "Done docker-registry.travelinsides.com/rocketchat:$LATEST_TAG"





# meteor build --directory ../rocketchat-build

