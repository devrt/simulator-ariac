FROM ros:melodic-ros-core

MAINTAINER Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl git python-pip && \
    pip install -U --no-cache-dir supervisor supervisor_twiddler && \
    apt-get clean

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    curl -L http://packages.osrfoundation.org/gazebo.key | apt-key add -

RUN apt-get update && \
    apt-get install -y ariac3 && \
    apt-get clean

RUN git clone --depth 1 https://github.com/osrf/gazebo_models.git /tmp/gazebo_models && \
    cp -r /tmp/gazebo_models/warehouse_robot /usr/share/gazebo-9/models/ && \
    rm -r /tmp/gazebo_models

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/opt/ros/melodic/share/osrf_gear"]

CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
