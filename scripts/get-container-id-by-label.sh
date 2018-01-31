#!/bin/sh
# Returns a docker container id that has a provided label
# Example usage: get-container-id-by-label my-label
docker ps -f "label=$@" --format "{{.ID}}" | head -n 1