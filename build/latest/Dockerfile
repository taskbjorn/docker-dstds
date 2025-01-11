FROM debian:buster-slim

ENV SERVER_TOKEN=
ENV SHARD_NAME=Master

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    apt-get install -y lsb-release && \
    sed -i "s#deb http://deb.debian.org/debian $(lsb_release -cs) main#deb http://deb.debian.org/debian $(lsb_release -cs) main contrib non-free#g" /etc/apt/sources.list && \
    sed -i "s#deb http://security.debian.org/debian-security $(lsb_release -cs)/updates main#deb http://security.debian.org/debian-security $(lsb_release -cs)/updates main contrib non-free#g" /etc/apt/sources.list

RUN echo steamcmd steam/question select "I AGREE" | debconf-set-selections && \
    echo steamcmd steam/license note '' | debconf-set-selections && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y ca-certificates lib32stdc++6 lib32gcc1 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386 steamcmd && \
    ln -s /usr/games/steamcmd /usr/bin/steamcmd

RUN groupadd --gid 1000 dst && \
    useradd --uid 1000 --gid 1000 --shell /bin/bash --create-home dst
USER dst

RUN mkdir -p /home/dst/.steam/servers/dst && \
    steamcmd +@ShutdownOnFailedCommand +login anonymous +force_install_dir /home/dst/.steam/servers/dst +app_update 343050 validate +quit

RUN cd ~/.steam/servers/dst/bin && \
    ./dontstarve_dedicated_server_nullrenderer -cluster MyDediServer -shard Master > /home/dst/.steam/servers/dst/bin/dst.log & \
    tail -f /home/dst/.steam/servers/dst/bin/dst.log | grep -m 1 '!!!! Your Server Will Not Start !!!!' && \
    rm /home/dst/.steam/servers/dst/bin/dst.log

COPY MyDediServer/cluster.ini /home/dst/.klei/DoNotStarveTogether/MyDediServer/
COPY MyDediServer/Master/worldgenoverride.lua MyDediServer/Master/server.ini /home/dst/.klei/DoNotStarveTogether/MyDediServer/Master/

CMD echo ${SERVER_TOKEN} > /home/dst/.klei/DoNotStarveTogether/MyDediServer/cluster_token.txt && \
    cd /home/dst/.steam/servers/dst/bin && \
    ./dontstarve_dedicated_server_nullrenderer -cluster MyDediServer -shard ${SHARD_NAME}