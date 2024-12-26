distrobox create \
  --image nbembedded/ros2_devenv:main \
  --name ros2_devenv

distrobox create --root \
  --image nbembedded/ros2_devenv:dnd \
  --name ros2_devenv_dnd