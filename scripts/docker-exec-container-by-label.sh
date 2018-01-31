#!/bin/sh
# Executes a command in a docker container that has a provided label
# Example usage: docker-exec-container-by-label my-label ls
docker exec $(get-container-id-by-label $1) $2