#!/usr/bin/env bash

set -u

source scripts/lib/colors.sh

help() {
    echo -e "
  Usage: famlydev up

  $(bold up) starts the current environment stack.
  "
    exit 1
}

case "${1: }" in
    completions)
        ;;
    help)
        help
        ;;
    *)
        make up
        ;;
esac
