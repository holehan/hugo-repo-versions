#!/bin/bash

HUGO_REMOTE="$(curl -s 'https://api.github.com/repos/gohugoio/hugo/releases/latest' | jq -r '.tag_name')"
HUGO_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/hugo/index.json | jq -r '.tag_name')"
SNAP_REMOTE="$(curl -s -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/hugo' | jq -r '.version')"
SNAP_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/snap/index.json | jq -r '.data.version')"
SNAP_EXTENDED_REMOTE="$(curl -s -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/hugo?channel=extended' | jq -r '.version')"
SNAP_EXTENDED_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/snap-extended/index.json | jq -r '.data.version')"
DOCKER_REMOTE="$(curl -s 'https://raw.githubusercontent.com/cibuilds/hugo/master/build-images.sh' | grep -Eo -m 1 'hugo:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed 's/^hugo://g')"
DOCKER_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/docker/index.json | jq -r '.data.version')"
MINIMALDOCKER_REMOTE="$(curl -s https://raw.githubusercontent.com/klakegg/docker-hugo/master/Dockerfile-base | grep -m 1 'ARG VERSION=' | sed 's/^ARG VERSION=//g')"
MINIMALDOCKER_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/minimaldocker/index.json | jq -r '.data.version')"
COPR_REMOTE="$(curl -s 'https://copr.fedorainfracloud.org/api_2/builds?project_id=12493&limit=1' | jq -r '.builds[0].build.built_packages[0].version')"
COPR_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/copr/index.json | jq -r '.data.version')"

# echo $HUGO_REMOTE
# echo $HUGO_LOCAL
# echo $SNAP_REMOTE
# echo $SNAP_LOCAL
# echo $SNAP_EXTENDED_REMOTE
# echo $SNAP_EXTENDED_LOCAL
# echo $DOCKER_REMOTE
# echo $DOCKER_LOCAL
# echo $MINIMALDOCKER_REMOTE
# echo $MINIMALDOCKER_LOCAL
# echo $COPR_REMOTE
# echo $COPR_LOCAL

if [ $HUGO_REMOTE != $HUGO_LOCAL ] ||
  [ $SNAP_REMOTE != $SNAP_LOCAL ] ||
  [ $SNAP_EXTENDED_REMOTE != $SNAP_EXTENDED_LOCAL ] ||
  [ $DOCKER_REMOTE != $DOCKER_LOCAL ] ||
  [ $MINIMALDOCKER_REMOTE != $MINIMALDOCKER_LOCAL ] ||
  [ $COPR_REMOTE != $COPR_LOCAL ]; then
  echo "Repo info needs updating. Triggering netlify rebuild."
  exit 0
fi
exit 1
