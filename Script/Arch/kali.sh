#!/bin/bash

# It's best to run this script with 'sudo' or as a user in the 'docker' group
# to ensure you have permissions to manage the Docker daemon.
sudo systemctl start docker

# --- Configuration ---
CONTAINER_NAME="manekali"
HOST_VOLUME_PATH="$PWD" # The path on your machine
CONTAINER_VOLUME_PATH="/data"     # The path inside the container

# --- Logic ---
# Check if a container with the specified name exists (either running or stopped).
# We redirect all output (&>) to /dev/null to perform a silent check.
if ! docker inspect "$CONTAINER_NAME" &> /dev/null; then
    echo "Container '$CONTAINER_NAME' not found. Creating a new one..."
    # If it doesn't exist, create and start it in detached mode (-d).
    docker run --name "$CONTAINER_NAME" \
               -itd \
               -v "$HOST_VOLUME_PATH:$CONTAINER_VOLUME_PATH" \
               kalilinux/kali-rolling
    docker exec -it "$CONTAINER_NAME" /bin/bash -c "apt update && apt install -y build-essential git wget curl sudo vim"
else
    docker start "$CONTAINER_NAME" > /dev/null
fi

# Execute the command passed to the script inside the container.
if [ $# -eq 0 ]; then
    docker exec -it -w "$CONTAINER_VOLUME_PATH" "$CONTAINER_NAME" /bin/bash
else
    docker exec -it -w "$CONTAINER_VOLUME_PATH" "$CONTAINER_NAME" "$@"
fi
