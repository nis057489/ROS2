#!/bin/bash

# Define image names and tags
IMAGE_NAME="nbembedded/ros2_devenv"
TAGDND="dnd"
TAGMAIN="main"

# Build the images in parallel
docker build -t $IMAGE_NAME:$TAGDND . -f RosDevEnvDnd.dockerfile &
BUILD1_PID=$!
docker build -t $IMAGE_NAME:$TAGMAIN . -f RosDevEnv.dockerfile &
BUILD2_PID=$!

# Wait for both builds to finish
wait $BUILD1_PID
wait $BUILD2_PID

# Authenticate (ensure you have already logged in to Docker Hub)
docker login

# Push the images in parallel
docker push $IMAGE_NAME:$TAGDND &
PUSH1_PID=$!
docker push $IMAGE_NAME:$TAGMAIN &
PUSH2_PID=$!

# Wait for both pushes to finish
wait $PUSH1_PID
wait $PUSH2_PID

echo "Both images have been built and pushed successfully!"
