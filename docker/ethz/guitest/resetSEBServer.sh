#!/bin/bash
podman-compose down
podman volume rm guitest_seb-server-mariadb
podman volume rm seb-server-mariadb
podman-compose up -d