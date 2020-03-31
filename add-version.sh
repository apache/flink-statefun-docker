#!/bin/bash -e

# Use this script to rebuild the Dockerfiles and all variants for a particular
# release. Before running this, you must first delete the existing release
# directory.
#
# TODO: to conform with other similar setups, this likely needs to become
# "update.sh" and be taught how to derive the latest version (e.g. 1.2.0) from
# a given release (e.g. 1.2) and assemble a .travis.yml file dynamically.
#
# See other repos (e.g. httpd, cassandra) for update.sh examples.

function usage() {
    echo >&2 "usage: $0 -s statefun-version -f flink-version"
}

function error() {
    local msg="$1"
    if [ -n "$2" ]; then
        local code="$2"
    else
        local code=1
    fi
    echo >&2 "$msg"
    exit "$code"
}

statefun_version= # Like 2.0.0
flink_version= # Like 1.10.0

while getopts s:f:h arg; do
  case "$arg" in
    s)
      statefun_version=$OPTARG
      ;;
    f)
      flink_version=$OPTARG
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      usage
      exit 1
      ;;
  esac
done

if [ -z "$statefun_version" ] || [ -z "$flink_version" ]; then
    usage
    exit 1
fi

gpg_key=`grep "$statefun_version" gpg_keys.txt | cut -d '=' -f2`

if [ -z "$gpg_key" ]; then
    error "Missing GPG key ID in gpg_keys.txt file for release $statefun_version"
fi

if [ -d "$statefun_version" ]; then
    error "Directory $statefun_version already exists; delete before continuing"
fi

echo -n >&2 "Generating Dockerfiles..."
dir="$statefun_version"
mkdir "$dir"

cp -r template/* "$dir"

sed \
    -e "s/%%STATEFUN_VERSION%%/$statefun_version/" \
    -e "s/%%FLINK_VERSION%%/$flink_version/" \
    -e "s/%%GPG_KEY%%/$gpg_key/" \
    "template/Dockerfile" > "$dir/Dockerfile"

echo >&2 " done."