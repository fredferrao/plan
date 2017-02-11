#!/usr/bin/env bash

set -u

# Switch directory to stack.
cd "$(dirname "$(readlink "$0")")/.." || exit

source scripts/lib/colors.sh
source scripts/lib/functional.sh
source scripts/lib/path.sh

help() {
    echo -e "
  Usage: stack <command> [arg] ...

  $(bold stack) is created with $(red ❤) by the developers of Famly.
  This is a copy-able version that's intended to help you build your own.

  Commands:
    help <command>              Output usage information for a specific command

  Managing the stack:
    up                          Prepare and run the development stack
    build                       Build images if necessary
    switch <environment>        Switch the development stack
    follow                      Follow logs
    status                      Gives a brief overview of the development environment

  Managing indiviual services:
    kick <service>              Kick a service and hope it helps (sends SIGHUP)
    attach <service>            Start a Bash shell inside the container
    restart <service>           Restart a specific container

  Infrastructure:
    db <command>                Manipulate the database

  Miscellaneous:
    time                        Tell the Docker Daemon what the time is

  Run \`$(bold stack help command)\` for more information on specific commands.
  "

    exit 1
}

commands() {
    ls scripts/commands/*.sh \
    | while read -r path; do echo $(path_basename $(path_notdir ${path})) ; done
}

command="${1: }"
arguments="${@:2}"

case ${command} in
    -h)
        help
        ;;
    --help)
        help
        ;;
    help)
        if [[ -z "${2: }" ]]
        then
            help
        else
            ./scripts/commands/${2}.sh help
        fi
        ;;
    "")
        help
        ;;
    *)
        if contains "$command" "$(commands)"
        then
            ./scripts/commands/$command.sh $arguments
        else
            echo ""
            echo -e "  $(red Error): Unknown command '$command'"
            help
        fi
        ;;
esac
