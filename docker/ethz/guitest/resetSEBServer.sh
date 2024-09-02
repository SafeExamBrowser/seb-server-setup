#!/bin/bash
podman-compose down
podman volume rm seb-server-test-db
podman-compose up -d