#!/bin/bash

HUGO_REMOTE="$(curl -s 'https://api.github.com/repos/gohugoio/hugo/releases/latest' | jq -r '.tag_name' | sed 's/^v//g')"
HUGO_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/hugo/index.json | jq -r '.tag_name' | sed 's/^v//g')"
SNAP_REMOTE="$(curl -s -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/hugo' | jq -r '.version' | grep -Eo -m 1 '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed 's/^v//g')"
SNAP_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/snap/index.json | jq -r '.data.version')"
SNAP_EXTENDED_REMOTE="$(curl -s -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/hugo?channel=extended' | jq -r '.version' | grep -Eo -m 1 '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed 's/^v//g')"
SNAP_EXTENDED_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/snap-extended/index.json | jq -r '.data.version')"
DOCKER_REMOTE="$(curl -s 'https://raw.githubusercontent.com/cibuilds/hugo/master/build-images.sh' | grep -Eo -m 1 'hugo:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed 's/^hugo://g')"
DOCKER_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/docker/index.json | jq -r '.data.version')"
MINIMALDOCKER_REMOTE="$(curl -s 'https://api.github.com/repos/klakegg/docker-hugo/releases/latest' | jq -r '.tag_name')"
MINIMALDOCKER_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/minimaldocker/index.json | jq -r '.data.version')"
COPR_REMOTE="$(curl -s 'https://copr.fedorainfracloud.org/api_3/build/list/?ownername=daftaupe&projectname=hugo&limit=1' | jq -r '.items[0].source_package.version' | grep -Eo -m 1 '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"
COPR_LOCAL="$(curl -s https://hugo-repo-versions.netlify.app/copr/index.json | jq -r '.data.version')"

echo "Hugo remote $HUGO_REMOTE"
echo "Hugo local $HUGO_LOCAL"
echo "Snap remote $SNAP_REMOTE"
echo "Snap local $SNAP_LOCAL"
echo "Snap extended remote $SNAP_EXTENDED_REMOTE"
echo "Snap extended local $SNAP_EXTENDED_LOCAL"
echo "Docker remote $DOCKER_REMOTE"
echo "Docker local $DOCKER_LOCAL"
echo "Minimal docker remote $MINIMALDOCKER_REMOTE"
echo "Minimal docker local $MINIMALDOCKER_LOCAL"
echo "COPR remote $COPR_REMOTE"
echo "COPR local $COPR_LOCAL"

if [ $HUGO_REMOTE != $HUGO_LOCAL ] ||
  [ $SNAP_REMOTE != $SNAP_LOCAL ] ||
  [ $SNAP_EXTENDED_REMOTE != $SNAP_EXTENDED_LOCAL ] ||
  [ $DOCKER_REMOTE != $DOCKER_LOCAL ] ||
  [ $MINIMALDOCKER_REMOTE != $MINIMALDOCKER_LOCAL ] ||
  [ $COPR_REMOTE != $COPR_LOCAL ]; then
  echo "Repo info needs updating. Triggering netlify rebuild."
  exit 1
fi
