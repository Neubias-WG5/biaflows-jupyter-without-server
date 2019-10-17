FROM jupyter/scipy-notebook:cf6258237ff9

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# ---------------------------------------------------------------------------------------------------------------------
# Install Docker
USER root
RUN apt-get update && apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable"
RUN apt update
RUN apt-cache policy docker-ce
RUN sudo apt install docker-ce -y
RUN usermod -aG docker ${NB_USER}

RUN service docker start
RUN service --status-all | grep docker
RUN nohub sh dockerd &
RUN service --status-all | grep docker

RUN apt-get install -y uidmap
RUN apt-get install kmod -y
# RUN modprobe ip_tables

USER ${NB_USER}
RUN echo 'export XDG_RUNTIME_DIR=/tmp/docker-1000' >> ~/.bashrc
RUN export DOCKER_HOST=unix:///tmp/docker-1000/docker.sock >> ~/.bashrc
RUN export export PATH=/home/jovyan/bin:$PATH >> ~/.bashrc
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}


