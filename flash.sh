#!/bin/bash

host="pi"
user="pirate"
password="hypriot"

usage() { echo "Usage: $0 [-h <hostname>] [-u <user>] [-p <password>] image" 1>&2; exit 1; }

while getopts ":h:u:p:" o; do
    case "${o}" in
        h)
            host=${OPTARG}
            ;;
        u)
            user=${OPTARG}
            ;;
        p)
            password=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${1}" ]; then
    usage
fi

key="$(cat ~/.ssh/id_rsa.pub)"

sed "s|<host>|${host}|" user-data.template.yml | sed "s|<user>|${user}|" | sed "s|<password>|${password}|" | sed "s|<ssh-key>|${key}|" > user-data.generated

flash --hostname ${host} -u ./user-data.generated $1

