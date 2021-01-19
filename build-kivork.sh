#!/bin/bash
set -x
# Take latest stable branch

TMP_DIR=$(mktemp -d -t ci-XXXXXXXXXX)

# get_latest_release() {
#   git fetch --tags
#   git tag | tail -1
# }

LATEST_TAG="3.3.4"

# LATEST_TAG=$(get_latest_release)
# # BRANCH="em_resumetoken_goto"
# COMMIT_ID="1e91b6d057c73d2aa5e892be71d27716f0a29035"



echo "Building tag: $LATEST_TAG"

# git checkout tags/3.3.3
# git cherry-pick 598daaee0eaf3f69667c7a120ade8e1c5d89fd5f
# git cherry-pick c12640c67bea4221a279143b7f78b71d8135db8a


# npm i
meteor build --directory $TMP_DIR
cp .docker/Dockerfile $TMP_DIR
cd $TMP_DIR
sudo docker build -t docker-registry.travelinsides.com/rocketchat:$LATEST_TAG -f Dockerfile .


sudo docker login https://docker-registry.travelinsides.com/
sudo docker push docker-registry.travelinsides.com/rocketchat:$LATEST_TAG
echo "Done docker-registry.travelinsides.com/rocketchat:$LATEST_TAG"





# meteor build --directory ../rocketchat-build

