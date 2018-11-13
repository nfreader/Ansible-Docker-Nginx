#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# enable interruption signal handling
trap - INT TERM

docker run --rm \
  -t $(tty &>/dev/null && echo "-i") \
  -v "$(pwd):/project" \
  -v "$HOME/.aws:/root/.aws" \
  mesosphere/aws-cli \
  "$@"