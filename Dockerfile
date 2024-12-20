# Base image
FROM ubuntu:noble

# ROS and Gazebo versions
ENV ROS_VERSION=jazzy
ENV GZ_VERSION=harmonic

# Set environment variables
ENV CC=clang
ENV CXX=clang++
ENV LANG=en_US.UTF-8
ENV QT_QPA_PLATFORM=xcb

# Install basic tools, Clang, and zsh
RUN apt-get update && apt-get install -y \
    zsh software-properties-common lsb-release gnupg wget clang && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Neovim
RUN add-apt-repository ppa:neovim-ppa/unstable && \
    apt-get update && apt-get -y install neovim && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install ROS2
RUN apt-get update && apt-get install -y curl && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list && \
    apt-get update && \
    apt-get install -y ros-dev-tools ros-$ROS_VERSION-desktop && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Gazebo
RUN curl -sSL https://packages.osrfoundation.org/gazebo.gpg -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" > /etc/apt/sources.list.d/gazebo-stable.list && \
    apt-get update && apt-get install -y ros-$ROS_VERSION-ros-gz && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install additional tools
RUN apt-get update && apt-get install -y \
    pipx openscad meshlab && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install VS Code (Code - OSS)
RUN apt-get update && apt-get install -y \
    software-properties-common apt-transport-https && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/packages.microsoft.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
    apt-get update && apt-get install -y code && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install NVIDIA Container Toolkit
RUN apt-get update && \
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
    && apt-get update && apt-get install -y nvidia-container-toolkit

# Configure pipx
ENV PATH="$PATH:/root/.local/bin"
ENV PIPX_BIN_DIR="/usr/local/bin"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
