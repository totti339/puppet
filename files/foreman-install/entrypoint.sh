#!/bin/bash

set -e

dockerize -template /foreman-installer/templates/install.tmpl:/foreman-installer/install.sh
chmod +x /foreman-installer/install.sh
cat /foreman-installer/install.sh
hostname
cat /etc/hosts
/foreman-installer/install.sh

exec "$@"