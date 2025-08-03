#!/bin/bash

# It's best to run this script with 'sudo' or as a user in the 'docker' group
# to ensure you have permissions to manage the Docker daemon.
sudo systemctl start docker

# --- Configuration ---
CONTAINER_NAME="manekali"

sudo docker rm -f "$CONTAINER_NAME"