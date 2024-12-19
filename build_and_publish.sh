#!/bin/bash

IMAGE_NAME="nbembedded/ros2_devenv"
TAG="dev"

# Build the image
docker build -t $IMAGE_NAME:$TAG .

# Authenticate (ensure you have already logged in to Docker Hub)
docker login

# Push the image
docker push $IMAGE_NAME:$TAG
