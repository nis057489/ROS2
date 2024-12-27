#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------------------------
# 0) Configuration
# --------------------------------------------------------------------
IMAGE_NAME="nbembedded/ros2_devenv"
ROS_DISTROS=("rolling" "jazzy")  # distros
VARIANTS=("nodnd" "dnd")  # nodnd = no Docker in Docker, dnd = Docker in Docker

# Dockerfiles for each variant
DOCKERFILE_NO_DND="RosDevEnv.dockerfile"
DOCKERFILE_DND="RosDevEnvDnd.dockerfile"

# --------------------------------------------------------------------
# 1) Build All Images in Parallel
# --------------------------------------------------------------------
echo "Building all images in parallel..."
build_pids=()

for distro in "${ROS_DISTROS[@]}"; do
  for variant in "${VARIANTS[@]}"; do

    # Determine which Dockerfile to use
    if [[ "$variant" == "dnd" ]]; then
      DOCKERFILE="$DOCKERFILE_DND"
    else
      DOCKERFILE="$DOCKERFILE_NO_DND"
    fi

    # Construct the final tag, e.g. "nbembedded/ros2_devenv:rolling-dnd"
    TAG="${IMAGE_NAME}:${distro}-${variant}"

    # Kick off the build in the background
    echo "  Building $TAG using $DOCKERFILE ..."
    docker build \
      --build-arg ROS_VERSION="$distro" \
      -t "$TAG" \
      -f "$DOCKERFILE" \
      . &

    # Capture the PID so we can wait for it later
    build_pids+=($!)
  done
done

# Wait for all builds to complete
for pid in "${build_pids[@]}"; do
  wait "$pid"
done

echo "All images have been built successfully!"

# --------------------------------------------------------------------
# 2) (Optional) Push All Images in Parallel
# --------------------------------------------------------------------
echo "Logging in to Docker..."
docker login || { echo "Docker login failed"; exit 1; }

echo "Pushing all images in parallel..."
push_pids=()

for distro in "${ROS_DISTROS[@]}"; do
  for variant in "${VARIANTS[@]}"; do
    TAG="${IMAGE_NAME}:${distro}-${variant}"
    echo "  Pushing $TAG..."
    docker push "$TAG" &

    # Capture the push PID
    push_pids+=($!)
  done
done

# Wait for all pushes to complete
for pid in "${push_pids[@]}"; do
  wait "$pid"
done

echo "All images have been pushed successfully!"
