#These must be changed depending on the ros version. Everything else should work automatically.
#Change distro based on Ros version
FROM docker.io/ubuntu:noble
ENV ROS_VERSION jazzy
#set this to the default version for your ros distro. It does not actually change what very of gazebo is being installed. I just could not automate it.
ENV GZ_VERSION harmonic

#advanced. Clang is being used for easier intergration with clangd I think.
ENV CC clang
ENV CXX clang++
ENV LANG LANG=en_US.UTF-8

#DO NOT CHANGE. This var allows gazebo to work correctly.
ENV QT_QPA_PLATFORM xcb

#zsh and the add-apt-repo commands
RUN apt-get update && apt-get install -y zsh software-properties-common lsb-release gnupg wget

#clang install (obviously)
RUN apt-get install -y clang

#Neovim install
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get update
RUN apt-get -y install neovim

#ROS2 install
RUN add-apt-repository universe
RUN apt-get update && apt-get install curl -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update
RUN apt-get install -y ros-dev-tools
RUN apt-get install -y ros-$ROS_VERSION-desktop


#gazebo install
RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
RUN apt-get update
# RUN apt-get install -y gz-harmonic 
RUN apt-get install -y ros-$ROS_VERSION-ros-gz


#onshape tools (pipx, open scad and meshlab)
# ENV PATH="$PATH:$HOME/.local/bin"
# ENV PIPX_BIN_DIR="/usr/local/bin"
RUN apt-get update
RUN apt-get install -y pipx
#need to figure this out later
# RUN pipx install onshape-to-robot
RUN apt-get install -y openscad meshlab
